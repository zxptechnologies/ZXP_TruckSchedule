using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_MainScheduleFiles
    {
        public vm_MainScheduleFiles()
        {
        }

        public vm_MainScheduleFiles(int id)
        {
            msFileId = id;
        }
        
        public int msFileId { get; private set; }
        public int? Msid { get; set; }
        public int? FileTypeId { get; set; }
        public string FileDescription { get; set; }
        public string Filepath { get; set; }
        public string FilenameNew { get; set; }
        public string FilenameOld { get; set; }


        public static implicit operator DomainModels.MainScheduleFiles(vm_MainScheduleFiles vmMSFile)
        {
            DomainModels.MainScheduleFiles msFile = new DomainModels.MainScheduleFiles(vmMSFile.msFileId);
            msFile.Msid = vmMSFile.Msid;
            msFile.FileTypeId = vmMSFile.FileTypeId;
            msFile.FileDescription = vmMSFile.FileDescription;
            msFile.Filepath = vmMSFile.Filepath;
            msFile.FilenameNew = vmMSFile.FilenameNew;
            msFile.FilenameOld = vmMSFile.FilenameOld;

            return msFile;
        }

        public static implicit operator vm_MainScheduleFiles(DomainModels.MainScheduleFiles msFile)
        {
            return new vm_MainScheduleFiles
            {
                msFileId = msFile.FileId,
                Msid = msFile.Msid,
                FileTypeId = msFile.FileTypeId,
                FileDescription = msFile.FileDescription,
                Filepath = msFile.Filepath,
                FilenameNew = msFile.FilenameNew,
                FilenameOld = msFile.FilenameOld
            };

        }

    }
}
