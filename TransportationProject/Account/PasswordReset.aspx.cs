using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks.Data;
using System.Data;

namespace TransportationProject.Account
{
    public partial class PasswordReset : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(Request.QueryString["token"]) && (!Page.IsPostBack))
                {
                    string tokenFromEmail = Request.QueryString["token"];
                    token.Value = tokenFromEmail;
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

        //protected void SubmitForm(EventArgs e, object sender)
        protected void ResetPassword(object sender, System.EventArgs e)
        {
           
            
            try
            {
                string hashedPassword = DataTransformer.PasswordHash(txtEnterPassword.Text);
                string hashedEmailToken = DataTransformer.createSHA256HashedString(token.Value.ToString()) ;

                if (string.IsNullOrEmpty(hashedPassword) || string.IsNullOrEmpty(hashedEmailToken))
                {
                    uMessage.Text = "Cannot reset password. Please check information before submitting. If problems persist, please contact the IT Department.";
                }

                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_ResetPasswordUsingToken"
                        , new SqlParameter("@pUserKey", hashedEmailToken)
                        , new SqlParameter("@pPassword", hashedPassword));
                

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in PasswordReset page ResetPassword(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw;
            }
        }

    }
}