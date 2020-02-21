using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TransportationProjectDataLayer;

namespace TransportationProject
{
    public partial class BulkReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TransportationProjectDataLayer.BulkReport bulkReport = new TransportationProjectDataLayer.BulkReport();
            TransportationProjectDataProvider dp = new TransportationProjectDataProvider();
            bulkReport = dp.GetBulkReport(21503, 3072);

            TransportationProjectDataLayer.TankStrapping newStrap= dp.GetTankStrap(1);
            newStrap.XGAL = "HELLO";
            dp.EditTankStrap(newStrap);

        }
    }
}