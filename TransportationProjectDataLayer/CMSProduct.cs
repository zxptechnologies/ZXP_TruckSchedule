using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace TransportationProjectDataLayer
{
    public class CMSProduct
    {
        public CMSProduct()
        {   
        }

        public string ProductID_CMS { get; set; }
        public string ProductName_CMS { get; set; }
        public float DockSpotTimeslotDuration { get; set; }

        public static CMSProduct adaptToProductCMS(IDataRecord record)
        {
            CMSProduct cmsProduct = new CMSProduct();
            cmsProduct.ProductID_CMS = record["ProductID_CMS"].ToString();
            cmsProduct.ProductName_CMS = record["ProductName_CMS"].ToString();
            cmsProduct.DockSpotTimeslotDuration = (int)record["DockSpotTimeslotDuration"];

            return cmsProduct;
        }
    }
}
