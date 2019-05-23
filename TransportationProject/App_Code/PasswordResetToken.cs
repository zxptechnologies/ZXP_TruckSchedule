using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class PasswordResetToken
    {
        public PasswordResetToken(){ }

        public PasswordResetToken(int userID, int expireMinutes ) {
            UserKey = Guid.NewGuid();
            DateTime now = DateTime.UtcNow;
            IssuedOn = now;
            ExpiresOn = now.AddMinutes(expireMinutes); 
            isValid = true;

        }

        public Guid UserKey { get;  set; }
        public int UserID { get; private set; }
        public DateTime IssuedOn { get;  set; }
        public DateTime ExpiresOn { get; set; }
        public bool isValid { get; private set; }



    }
}