using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TransportationProjectDataLayer;

namespace TransportationProject
{
    public partial class Admin_TruckscheduleEventsCalendar : System.Web.UI.Page
    {
        private List<TransportationProjectDataLayer.ViewModels.vm_CalendarEvents> invalidDates;
        protected void Page_Load(object sender, EventArgs e)
        {

            Calendar1.Caption = "Events Calendar";
            Calendar1.FirstDayOfWeek = FirstDayOfWeek.Sunday;
            Calendar1.NextPrevFormat = NextPrevFormat.ShortMonth;
            Calendar1.TitleFormat = TitleFormat.Month;
            Calendar1.ShowGridLines = true;
            Calendar1.DayStyle.Height = new Unit(50);
            Calendar1.DayStyle.Width = new Unit(150);
            Calendar1.DayStyle.HorizontalAlign = HorizontalAlign.Center;
            Calendar1.DayStyle.VerticalAlign = VerticalAlign.Middle;
            Calendar1.OtherMonthDayStyle.BackColor = System.Drawing.Color.AliceBlue;
            invalidDates = GetEventDates();
        }



        [System.Web.Services.WebMethod]
        public static List<TransportationProjectDataLayer.ViewModels.vm_CalendarEvents> GetEventDates()
        {
            List<TransportationProjectDataLayer.ViewModels.vm_CalendarEvents> eventDates = new List<TransportationProjectDataLayer.ViewModels.vm_CalendarEvents>();
            try
            {

                TransportationProjectDataLayer.TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.CalendarEvents> CEvents =  dProvider.GetDatesToDisableInSchedule();
                eventDates = CEvents.Select<TransportationProjectDataLayer.DomainModels.CalendarEvents, TransportationProjectDataLayer.ViewModels.vm_CalendarEvents>(x => x).ToList();
            }
            catch (Exception ex)
            {
                string msg = ex.ToString();
            }
            return eventDates;

        }


        protected void Calendar1_DayRender(object source, DayRenderEventArgs e)
        {

            foreach (TransportationProjectDataLayer.ViewModels.vm_CalendarEvents vmDates in invalidDates)
            {
                if (0 == e.Day.Date.CompareTo(vmDates.EventDate))
                {
                    Literal literal1 = new Literal();
                    literal1.Text = "<br/>";
                    e.Cell.Controls.Add(literal1);
                    Label label1 = new Label();
                    label1.Text = vmDates.Description;
                    label1.Font.Size = new FontUnit(FontSize.Small);
                    e.Cell.Controls.Add(label1);
                    e.Cell.BackColor = System.Drawing.Color.LightGray;
                }

            }
            
        }
        
    }
}