using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_FileTypes
    {
        public vm_FileTypes()
        {
        }
        public vm_FileTypes(int id, string type)
        {
            ID = id;
            FileType = type;
        }
        public int ID { get; set; }
        public string FileType { get; set; }

        public static implicit operator DomainModels.FileTypes(vm_FileTypes vmFType)
        {
            DomainModels.FileTypes Ftype = new DomainModels.FileTypes(vmFType.ID, vmFType.FileType);
            return Ftype;
        }

        public static implicit operator vm_FileTypes(DomainModels.FileTypes FType)
        {

            return new vm_FileTypes
            {
                ID = FType.FileTypeId,
                FileType = FType.FileType
            };

        }

    }
}
