using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class Sample
    {
        public Sample() { }
        public int SampleID { get; set; }
        public int MSID { get; set; }
        public int PODetailsID { get; set; }
        public int PONumber { get; set; }
        public string ProductID_CMS { get; set; }
        public int? FileID { get; set; }
        public string Filepath { get; set; }
        public string FilenameOld { get; set; }
        public string LotusID { get; set; }
        public DateTime ? TimeSampleTaken { get; set; }
        public DateTime ? TimeSampleSent { get; set; }
        public DateTime ? TimeSampleReceived { get; set; }
        public int didLabNotReceived { get; set; }
        public string Comments { get; set; }
        public string FilenameNew { get; set; }
        public bool TestApproved { get; set; }
        public string TrailerNumber { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string bypassCOFAComment { get; set; }
        public decimal? SpecificGravity { get; set; }
        public bool isOpenInCMS { get; set; }
        public bool isRejected { get; set; }
        public string ProductName_CMS { get; set; }

    }
}