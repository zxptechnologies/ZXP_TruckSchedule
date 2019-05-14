using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_CalendarEvents
    {
        public vm_CalendarEvents()
        { }
        public vm_CalendarEvents(DateTime eventDate, string description, bool isDateDisabled)
        {
            EventDate = eventDate;
            Description = description;
            isDisabled = isDateDisabled;

        }
        
        public DateTime EventDate { get; set; }
        public string Description { get; set; }
        public bool isDisabled { get; set; }
        public static implicit operator DomainModels.CalendarEvents(vm_CalendarEvents vmUDate)
        {
            DomainModels.CalendarEvents uDate = new DomainModels.CalendarEvents(vmUDate.EventDate, vmUDate.Description, vmUDate.isDisabled);
            return uDate;
        }

        public static implicit operator vm_CalendarEvents(DomainModels.CalendarEvents uDate)
        {

            return new vm_CalendarEvents
            {
                EventDate = uDate.EventDate,
                Description = uDate.Description
            };

        }
    }
}
