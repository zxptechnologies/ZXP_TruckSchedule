<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_TruckscheduleEventsCalendar.aspx.cs" Inherits="TransportationProject.Admin_TruckscheduleEventsCalendar" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<title>Default functionality</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
  <link rel="stylesheet" href="/resources/demos/style.css"/>
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script>
  $( function() {
    $( "#datepicker" ).datepicker();
  } );
  </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ScriptMode="Release">
    <Scripts>
        <asp:ScriptReference Name="MicrosoftAjax.js" Path="Scripts/WebForms/MSAjax/MicrosoftAjax.js" />
    </Scripts>
</asp:ScriptManager>
<script type="text/javascript">

    function getCalendarEvents() {

        PageMethods.GetEventDates(onSuccess_getEventDates, onFail_getEventDates);
    }

    function onSuccess_getEventDates(values) {
        let desc = values[0]["Description"];
        alert("Success: " + desc)
    }
    function onFail_getEventDates() {
        alert("Failed")
    }


</script>

    <asp:Calendar ID="Calendar1" runat="server"  OnDayRender ="Calendar1_DayRender"></asp:Calendar>
    
    <form>
        <p>Date: <input type="text" id="datepicker"  onchange="getCalendarEvents()" /></p>
        <p><label for="eventDescription">Event Description:</label><input id="eventDescription" type="text"/></p>
        <p><label for="isDisabled">Disabled for Truck schedule? (Check for yes): </label><input id="isDisabled" type="checkbox"/></p>
        <p><button >Create New Event</button> <button>Submit Change</button> <button>Delete Event</button></p>
    </form>


</asp:Content>
