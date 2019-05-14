using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer
{
    class MessageLog
    {
        
        public MessageType LogType { get; private set; }
        public string Message { get; private set; }

        public MessageLog()
        {
            LogType = MessageType.None;
            Message = string.Empty;
        }
        public MessageLog(MessageType logtype,string message)
        {
            LogType = logtype;
            Message = message;
        }
        public string CreateAuditLogMessage()
        {
            string msg = string.Empty;
            DateTime utcnow = DateTime.UtcNow;
            msg = string.Concat( " ON UTC ", utcnow, ". MessageType: ", LogType, ", Message: ", Message);

            return msg;

        }

    }

    public enum MessageType
    {
        None = 0,
        Info = 1,
        Exception = 2

    }

}
