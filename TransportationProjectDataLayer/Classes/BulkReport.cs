using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer
{
    public class BulkReport
    {
        public BulkReport(int msid, int CreatedBy, int LastModBy, int BeforeStrapId, int AfterStrapID, DateTime LastModDate)
        {
            MSID = msid;
            CreatedByUserID = CreatedBy;
            LastModifiedByUserID = LastModBy;
            BeforeTankStrap = new TankStrapping(BeforeStrapId);
            AfterTankStrap = new TankStrapping(AfterStrapID);
        }

        public BulkReport()
        {
            MSID = 0;

        }

        public int MSID { get; private set; }
        public int CreatedByUserID { get; private set; }
        public int LastModifiedByUserID { get; set; }
        public string LoaderUnloaderName { get; set; }
        public string LogNumber { get; set; }
        public string ReleaseNumber { get; set; }
        public DateTime? InputStartUTC { get; set; }
        public DateTime? InputEndUTC { get; set; }
        public string TankNumber { get; set; }
        public TankStrapping BeforeTankStrap { get; set; }
        public TankStrapping AfterTankStrap { get; set; }
        public double? TotalGalLoadedOrUnloaded { get; set; }
        public double? FlushGal { get; set; }
        public double? TotalNetGal { get; set; }
        public double? BOLNetWeight { get; set; }
        public string Comments { get; set; }
        public DateTime LastModifiedDateTimeUTC { get; set; }
        public string Seals { get; set; }
    }
}
