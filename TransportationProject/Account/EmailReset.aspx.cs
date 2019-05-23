using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using Microsoft.ApplicationBlocks.Data;
using System.Configuration;

namespace TransportationProject.Account
{
    public partial class EmailReset : System.Web.UI.Page
    {
        protected static String sql_connStr;
        void Page_PreInit(Object sender, EventArgs e)
        {
            if (Request.Browser.IsMobileDevice)
            {
                this.MasterPageFile = "~/Site.Mobile.master";
            }
            else
            {
                this.MasterPageFile = "~/Site.master";
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
             try
            {
                        sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                        if (sql_connStr == String.Empty)
                        {
                            throw new Exception("Missing SQLConnectionString in web.config");
                        }
                     
                
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in EmailReset Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

        }

        protected void SubmitForm(object sender, System.EventArgs e)
        {
            String userEmail = emailAddress.Text;
            int userCount = getCountOfUsersWithEmail(userEmail);
            if (1 < userCount)
            {
                uMessage.Text = "Cannot send password reset. More than 1 account has been found with same email. Please contact the IT Department.";
            }
            else if (0 == userCount)
            {
                uMessage.Text = "No user found. Please contact the IT Department if you need an account.";
            }
            else {
                int UserID = getUserIDForEmail(userEmail);
                
                
                uMessage.Text = ProcessUserResetTokenRequest(UserID);  
            }
        }


        protected string ProcessUserResetTokenRequest(int UserID)
        {
            try
            {

                PasswordResetToken token = checkIfValidPasswordResetTokenExists(UserID);
                DateTime now = DateTime.UtcNow;
                DateTime timeMinimumForResend = now;
                if (!(Guid.Empty == token.UserKey))
                {
                    int ResetSpamTimeLimitInMinutes = int.Parse(ConfigurationManager.AppSettings["PasswordResetTokenSpamTimeLimitInMinutes"]);
                    timeMinimumForResend = token.IssuedOn.AddMinutes(ResetSpamTimeLimitInMinutes);
                }

                if (now.CompareTo(timeMinimumForResend) > 0 || Guid.Empty == token.UserKey)
                {
                    if (!(Guid.Empty == token.UserKey))
                    {
                        InvalidatePasssworResetToken(UserID);
                    }
                    PasswordResetToken newToken = CreateNewUserPasswordResetToken(UserID);
                    SendPasswordResetEmail(newToken);
                    return "Password reset email has been sent."; 

                }
                else
                {
                    //display to user that not enough time has passed since last reset request.

                    return string.Concat("Not enough time has passed. To prevent spamming, please wait until "
                            , timeMinimumForResend.ToLocalTime().ToShortDateString()
                            , " "
                            , timeMinimumForResend.ToLocalTime().ToShortTimeString(), 
                            " before requesting another reset.") ;
                }

            }

            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset ProcessUserResetTOkenRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw;
            }
        }
        protected PasswordResetToken CreateNewUserPasswordResetToken(int UserID)
        {

            PasswordResetToken token = new PasswordResetToken();
            try
            {


                int expirationLimitInMinutes = int.Parse(ConfigurationManager.AppSettings["PassworResetTokenExpiryMinutes"]);
                token = new PasswordResetToken(UserID, expirationLimitInMinutes);

                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_createPasswordResetToken"
                    , new SqlParameter("@pUserKeyHashed", DataTransformer.createSHA256HashedString(token.UserKey.ToString())  )
                    , new SqlParameter("@pUserID", UserID)
                    , new SqlParameter("@pIssueDate", token.IssuedOn)
                    , new SqlParameter("@pExpireDate", token.ExpiresOn)
                    , new SqlParameter("@pValid", token.isValid)
                    );



            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset CreateNewUserPasswordResetToken(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw;
            }
            return token;

        }


        protected PasswordResetToken checkIfValidPasswordResetTokenExists(int UserID)
        {
            PasswordResetToken prToken = new PasswordResetToken();
            try
            {
            
                SqlDataReader reader = SqlHelper.ExecuteReader(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getPasswordToken", new SqlParameter("@pUserID", UserID));
                while (reader.Read())
                {
                    Guid? userKey = reader.GetValueOrDefault<Guid>("UserKey");
                    DateTime? IssuedOn = reader.GetValueOrDefault<DateTime>("IssuedOn");
                    DateTime? ExpiresOn = reader.GetValueOrDefault<DateTime>("ExpiresOn");
                    if (!(Guid.Empty == userKey || default(DateTime) == IssuedOn || default(DateTime) == ExpiresOn))
                    {
                        DateTime now = DateTime.UtcNow;
                        if (ExpiresOn > now && IssuedOn < ExpiresOn)
                        {
                            prToken.UserKey = (Guid)userKey;
                            prToken.IssuedOn = (DateTime)IssuedOn;
                            prToken.ExpiresOn = (DateTime)ExpiresOn;
                        }
                        else
                        {
                            InvalidatePasssworResetToken(UserID);

                        }
                    }
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset checkIfValidPasswordResetTokenExists(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw;
            }

            return prToken;
        }

        public int getCountOfUsersWithEmail(string email)
        {
            int count = 0;
            try
            {

                
                count = (int) SqlHelper.ExecuteScalar(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getNumberOfUsersWithEmail", new SqlParameter("@pEmail", email));

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset getCountOfUsersWithEmail(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw;
            }

            return count;
        }


        public int getUserIDForEmail(string email)
        {
            int userID = 0;
            try
            {


                userID = (int)SqlHelper.ExecuteScalar(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getUserIDFromEmail", new SqlParameter("@pEmail", email));

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset getUserIDForEmail(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw;
            }

            return userID;
        }

      
        protected void SendPasswordResetEmail(PasswordResetToken prToken)
        {
            

            try
            {

                TruckScheduleConfigurationKeysHelper tsConfig = new TruckScheduleConfigurationKeysHelper();

                if (String.Empty == tsConfig.truckReservationEmail)
                {
                    throw new Exception("Missing Truck Reservation Email in web.config");
                }
                String userEmail = emailAddress.Text;
                string PassworResetTokenURL = ConfigurationManager.AppSettings["PassworResetTokenURL"];
                if (String.Empty == PassworResetTokenURL)
                {
                    throw new Exception("Missing PassworResetTokenURL in web.config");
                }

                string validDatetime = string.Concat(prToken.ExpiresOn.ToLocalTime().ToShortDateString(), " ", prToken.ExpiresOn.ToLocalTime().ToShortTimeString());
                string resetURL = string.Concat(PassworResetTokenURL, "PasswordReset.aspx?token=", prToken.UserKey.ToString());
                string emailbody = string.Concat("<p>A password change request was recently made for your ZXP Truck Schedule account.</p>"
                                                , "<p>Please click the link below to go to to the reset password page.</p>"
                                                , "<p>If you did not request for a password reset or no longer need a reset, no action is needed.</p>"
                                                , "<p>If you have any questions or comments, please contact the IT department.</p>");
                string linkSection = string.Concat("<p>This link will be valid until "
                                                , validDatetime
                                                , ".</p><p><a href='"
                                                ,resetURL
                                                ,"'>Reset Password</a><p>");

                AlertMessenger aMsgr = new AlertMessenger();
                aMsgr._emailAddressesTO.Add(userEmail);
                aMsgr._from = tsConfig.truckReservationEmail;
                aMsgr._subject = "ZXP Truck Schedule Application Password Reset";

                aMsgr._body = string.Concat(emailbody, linkSection);
                aMsgr.sendAlertMessage(true);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset SendPasswordResetEmail(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        protected void InvalidatePasssworResetToken(int UserID)
        {
            try
            {
                 SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_invalidatePasswordResetToken"
                    ,  new SqlParameter("@pUserID", UserID) );

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EmailReset getUserIDForEmail(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw;
            }
        }

    }
}