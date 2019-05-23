using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class TimeslotDayOfWeek
    {
        public TimeslotDayOfWeek() {
            DayofWeekID = -1;
            DayofWeekShortName = string.Empty;
        }
        public TimeslotDayOfWeek(int id, string shortname)
        {
            DayofWeekID = id;
            DayofWeekShortName = shortname;
        }


        public int DayofWeekID { get; set; }
        public string DayofWeekShortName { get; set; }

        public static TimeslotDayOfWeek GetDayOfWeekID(DateTime selectedDate)
        {
           
            int dow = Convert.ToInt32(selectedDate.DayOfWeek);
            switch (dow)
            {
                case 0:
                     return new TimeslotDayOfWeek(dow, "SU");
                case 1:
                    return new TimeslotDayOfWeek(dow, "M");
                case 2:
                    return new TimeslotDayOfWeek(dow, "T");
                case 3:
                    return new TimeslotDayOfWeek(dow, "W");
                case 4:
                    return new TimeslotDayOfWeek(dow, "TH");
                case 5:
                    return new TimeslotDayOfWeek(dow, "F");
                case 6:
                    return new TimeslotDayOfWeek(dow, "SA");
                default:
                    break;
            }
            return new TimeslotDayOfWeek();
        }

    }
}