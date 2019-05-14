using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class FileTypes
    {
        public FileTypes()
        {
        }
        public FileTypes(int id, string type)
        {
            FileTypeId = id;
            FileType = type;
        }
        public int FileTypeId { get; private set; }
        public string FileType { get; private set; }

    }
}
