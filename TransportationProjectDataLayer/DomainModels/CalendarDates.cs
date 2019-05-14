using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class CalendarEvents
    {
        public CalendarEvents()
        { }
        public CalendarEvents(int newid, DateTime eventDate, string description, bool isDateDisabled)
        {
            Id = newid;
            EventDate = eventDate;
            Description = description;
            isDisabled = isDateDisabled;
        }

        public CalendarEvents(DateTime eventDate, string description, bool isDateDisabled)
        {
            EventDate = eventDate;
            Description = description;
            isDisabled = isDateDisabled;
        }

        public int Id { get; private set; }
        public DateTime EventDate { get; set; }
        public string Description { get; set; }
        public bool isDisabled { get; set; }

    }
}
