using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class Status
    {
        public Status(){}

        public Status(int id, string text, int ? statObjID) {
            StatusID = id;
            StatusText = text;
            StatusObjectID = statObjID;
        }

        public int StatusID { get; private set; }
        public string StatusText { get; private set; }
        public int? StatusObjectID { get; set; }
    }
}
