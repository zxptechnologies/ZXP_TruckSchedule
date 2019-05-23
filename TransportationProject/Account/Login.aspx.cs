using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;
using System.Transactions;
using System.Web;
using System.Web.Security;
using System.Web.UI;


namespace TransportationProject.Account
{
    public partial class Login : Page
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
                string errorText = Request.QueryString["ErrorText"];
                if (!string.IsNullOrEmpty(errorText))
                {
                    LabelError.Text = errorText;
                }
                else
                {
                    LabelError.Text = string.Empty;
                }
                HttpCookie cookie = Request.Cookies[FormsAuthentication.FormsCookieName];
                string isLoggingOut = Request.QueryString["out"];
                if (null != cookie && !string.IsNullOrEmpty(cookie.Value))
                {
                    FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(cookie.Value);
                    ZXPUserData zxpUD = new ZXPUserData();
                    zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);
                    LoginControl.UserName = zxpUD._UserName;


                    if (zxpUD._isValid)
                    {
                        if (zxpUD.hasLoaderOrYMAccessOnly() && string.IsNullOrEmpty(isLoggingOut))
                        {

                            Response.Redirect("/loaderMobile.aspx", false);
                            Context.ApplicationInstance.CompleteRequest(); // end response
                        }
                        else {
                            Response.Redirect("/default.aspx", false);
                            Context.ApplicationInstance.CompleteRequest(); // end response
                        }
                        LabelError.Text = "Already logged in. Please navigate to the page you would like to see by using the links in the menu above.";
                    }
                    else
                    {
                        if(zxpUD.hasLoaderOrYMAccessOnly())
                        {

                            Response.Redirect("/loaderMobile.aspx", false);
                            Context.ApplicationInstance.CompleteRequest(); // end response
                        }
                        else
                        {

                            String pageURL = FormsAuthentication.GetRedirectUrl(LoginControl.UserName, LoginControl.RememberMeSet);
                            Response.Redirect(pageURL,false);
                            Context.ApplicationInstance.CompleteRequest(); // end response

                        }

                    }
                    AuditLog aLog = new AuditLog(zxpUD._uid);
                    aLog.createNewAuditLogEntry(aLog);

                }
                
                if (!string.IsNullOrEmpty(isLoggingOut))
                {
                    int islogout = 0;
                    bool isValidLogout = int.TryParse(isLoggingOut, out islogout);
                    if (isValidLogout && 1 == islogout)
                    {
                        Session.Abandon();
                        System.Web.Security.FormsAuthentication.SignOut();
                        //Response.Redirect("~/Account/Login.aspx");
                    }
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Login Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Login Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }


        public ZXPUserData GetLoginCredentials()
        {
            ZXPUserData zxpUD = new ZXPUserData();
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    string hashedPassword = MD5Hash(LoginControl.Password);

                    sqlCmdText = "SELECT TOP 1 UserID, isAdmin,  isDockManager,  isInspector,  isGuard,  isLabPersonel,  isLoader,  isYardMule, canViewReports, isLabAdmin, isAccountManager," +
                                                "UserName, FirstName, LastName FROM dbo.Users WHERE [Password] = @UPASS AND UserName = @UNAME AND isDisabled = 0";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UNAME", LoginControl.UserName), new SqlParameter("@UPASS", hashedPassword));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        zxpUD = new ZXPUserData(Convert.ToInt32(row.ItemArray[0]), true, Convert.ToBoolean(row.ItemArray[1]), Convert.ToBoolean(row.ItemArray[2]), Convert.ToBoolean(row.ItemArray[3]), 
                                                Convert.ToBoolean(row.ItemArray[4]), Convert.ToBoolean(row.ItemArray[5]), Convert.ToBoolean(row.ItemArray[6]), Convert.ToBoolean(row.ItemArray[7]), 
                                                Convert.ToBoolean(row.ItemArray[8]), Convert.ToBoolean(row.ItemArray[9]), Convert.ToBoolean(row.ItemArray[10]), Convert.ToString(row.ItemArray[11]), 
                                                Convert.ToString(row.ItemArray[12]), Convert.ToString(row.ItemArray[13]));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Login GetLoginCredentials(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return zxpUD;
        }
        protected void BtnLogin_ForgotPassword(object sender, EventArgs e)
        {
            //Response.Redirect("~/Account/EmailReset.aspx");
            Response.Redirect("~/Account/EmailReset.aspx", false);
            Context.ApplicationInstance.CompleteRequest(); // end response
        }
            protected void BtnLogin_Click(object sender, EventArgs e)
        {

            ZXPUserData zxpUD = GetLoginCredentials();
            try
            {
                if (zxpUD._uid > 0)
                {

                    AuditLog aLog = new AuditLog(zxpUD._uid);
                    aLog.createNewAuditLogEntry(aLog);

                    string strUserData = zxpUD.SerializeZXPUserData(zxpUD);

                    System.Web.Security.FormsAuthenticationTicket ticket = new System.Web.Security.FormsAuthenticationTicket(1, LoginControl.UserName, DateTime.Now, DateTime.Now.AddDays(5), LoginControl.RememberMeSet, strUserData);
                    string enticket = System.Web.Security.FormsAuthentication.Encrypt(ticket);
                    System.Web.HttpCookie authcookie = new System.Web.HttpCookie(System.Web.Security.FormsAuthentication.FormsCookieName, enticket);
                    if (ticket.IsPersistent)
                    {
                        authcookie.Expires = ticket.Expiration;
                    }
                    Response.Cookies.Add(authcookie);


                    string logMsg = string.Concat("btnLogin_click : ", zxpUD._UserName, " cookie: ", authcookie.Value.ToString());
                    ErrorLogging.WriteEvent(logMsg, EventLogEntryType.Information);

                    string pageURL = System.Web.Security.FormsAuthentication.GetRedirectUrl(LoginControl.UserName, LoginControl.RememberMeSet);
                    Response.Redirect(pageURL);

                   // Response.Redirect(pageURL, false);
                   // Context.ApplicationInstance.CompleteRequest(); // end response
                }
                else
                {
                    string ErrorText = "Login failed. Please check your Username and Password and try again.";
                    string pageURL = Request.Url.AbsolutePath + "?ErrorText=" + ErrorText;
                    Response.Redirect(pageURL);
                   // Response.Redirect(pageURL, false);
                    //Context.ApplicationInstance.CompleteRequest(); // end response


                }
            }
            catch (System.Threading.ThreadAbortException ex)
            {
                ex.ToString();
                //do nothing - caused by response.redirect
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Login BtnLogin_Click(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }


        //password hasher
        private static string MD5Hash(string INPUT)
        {
            MD5 md5Hasher = MD5.Create();
            byte[] data = md5Hasher.ComputeHash(Encoding.UTF8.GetBytes(INPUT));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            return sBuilder.ToString();
        }//end of private static string getMD5Hash(string INPUT)


    }
}