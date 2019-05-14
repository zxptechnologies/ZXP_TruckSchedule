using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class MainScheduleFiles
    {
        public MainScheduleFiles()
        {
        }

        public MainScheduleFiles(int id)
        {
            FileId = id;
        }
        
        public int FileId { get; private set; }
        public int? Msid { get; set; }
        public int? FileTypeId { get; set; }
        public string FileDescription { get; set; }
        public string Filepath { get; set; }
        public string FilenameNew { get; set; }
        public string FilenameOld { get; set; }
        public bool IsHidden { get; set; }


    }
}
