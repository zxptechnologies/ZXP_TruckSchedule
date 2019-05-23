using System;
using System.Web;
using System.Diagnostics;

namespace TransportationProject
{
    [Serializable]
    public class ZXPUserData
    {
        public int _uid { get; private set; }
        public bool _isValid { get; private set; }
        public bool _isAdmin { get; private set; }
        public bool _isDockManager { get; private set; }
        public bool _isInspector { get; private set; }
        public bool _isGuard { get; private set; }
        public bool _isLabPersonnel { get; private set; }
        public bool _isLoader { get; private set; }
        public bool _isYardMule { get; private set; }
        public bool _isLabAdmin { get; private set; }
        public bool _isAccountManager { get; private set; }
        public bool _canViewReports { get; private set; }
        public string _UserName { get; private set; }
        public string _FirstName { get; private set; }
        public string _LastName { get; private set; }

        public ZXPUserData()
        {
            this._uid = -1;
            this._isValid = false;
            this._isAdmin = false;
            this._isDockManager = false;
            this._isInspector = false;
            this._isGuard = false;
            this._isLabPersonnel = false;
            this._isLoader = false;
            this._isYardMule = false;
            this._isLabAdmin = false;
            this._isAccountManager = false;
            this._canViewReports = false;
            this._UserName = string.Empty;
            this._FirstName = string.Empty;
            this._LastName = string.Empty;

        }

        public ZXPUserData(int UserID, bool isValid, bool isAdmin, bool isDockManager, bool isInspector, bool isGuard, bool isLabPersonel, bool isLoader, bool isYardMule, bool canViewReports, bool isLabAdmin, bool isAccountManager,  string UserName, string FirstName, string LastName) 
        {
            this._uid = UserID;
            this._isValid = isValid;
            this._isAdmin = isAdmin;
            this._isDockManager = isDockManager;
            this._isInspector = isInspector;
            this._isGuard = isGuard;
            this._isLabPersonnel = isLabPersonel;
            this._isLoader = isLoader;
            this._isYardMule = isYardMule;
            this._canViewReports = canViewReports;
            this._isLabAdmin = isLabAdmin;
            this._isAccountManager = isAccountManager;
            this._UserName = UserName;
            this._FirstName = FirstName;
            this._LastName = LastName;
        
        }

        public bool hasLoaderOrYMAccessOnly() {
            if ( (this._isLoader || this._isYardMule) 
                && !(   this._isAdmin 
                        || this._isAccountManager 
                        || this._isGuard 
                        || this._isDockManager
                        || this._isInspector
                        || this._isLabAdmin
                        || this._isLabPersonnel))
            {
                return true;
            }
            return false;
        }
        public bool CanUserCRUDSchedules() {

            if (this._isAdmin || this._isAccountManager || this._isGuard)
            {
                return true;
            }
            return false;
        }

        public ZXPUserData GetScrubbedUserData() {
            return new ZXPUserData(-1, false, this._isAdmin, this._isDockManager, this._isInspector, this._isGuard, this._isLabPersonnel, this._isLoader, this._isYardMule, this._canViewReports, this._isLabAdmin, this._isAccountManager, this._UserName, this._FirstName, this._LastName);
        }
        public string SerializeZXPUserData(ZXPUserData UserData)
        {
            System.Runtime.Serialization.Formatters.Binary.BinaryFormatter bf = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            System.IO.MemoryStream mem = new System.IO.MemoryStream();
            bf.Serialize(mem, UserData);
            return System.Convert.ToBase64String(mem.ToArray());
        }

        public static ZXPUserData DeserializeZXPUserData(string strUserData)
        {
            System.Runtime.Serialization.Formatters.Binary.BinaryFormatter bf = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            System.IO.MemoryStream mem = new System.IO.MemoryStream(System.Convert.FromBase64String(strUserData));
            ZXPUserData ud = (ZXPUserData)bf.Deserialize(mem);
            return ud;
        }


        public static ZXPUserData GetZXPUserDataFromCookie()
        {
            ZXPUserData zxpUD = new ZXPUserData();
            try
            {

                HttpCookie cookie = HttpContext.Current.Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                if (null != cookie)
                {
                    if (!string.IsNullOrEmpty(cookie.Value))
                    {
                        System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                        zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);
                    }
                }

            }
            catch (Exception ex)
            {

                string strErr = " Exception Error in ZXPUserData GetZXPUserDataFromCookie(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                throw;
            }

            return zxpUD;
        }
    }
}