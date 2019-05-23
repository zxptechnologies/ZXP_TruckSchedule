<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="alertsprocessing.aspx.cs" Inherits="TransportationProject.alertsprocessing"EnableViewState="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Alerts Processing Page</h1>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ScriptMode="Release">
        <Scripts>
            <asp:ScriptReference Name="MicrosoftAjax.js" Path="Scripts/WebForms/MSAjax/MicrosoftAjax.js" />
        </Scripts>

    </asp:ScriptManager>

     <script type="text/javascript">
         <%--EMAIL TEST FUNCTIONS--%>
         function onReturn_testEmail(value, ctx, methodName) {
             if (value && value.length === 2) { 
                 alert(value[1].toString());
             }
         }

         function onclick_sendMsg() {
             PageMethods.testEmail(onReturn_testEmail, onReturn_testEmail);
         }
         <%--EMAIL TEST FUNCTIONS--%>
     </script>
    
    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <h2>Demurrage Alerts</h2>
        <asp:Table ID="tblDemmurage" 
            runat="server" 
            Font-Size="Large" 
            Width="1500" 
            Font-Names="Palatino"
            BackColor="LightBlue"
            BorderColor="Black"
            BorderWidth="2"
            ForeColor="Black"
            CellPadding="5"
            CellSpacing="5"
            >
            <asp:TableHeaderRow ID="tblHeaderDemurrage" 
                runat="server" 
                ForeColor="Black"
                BackColor="LightBlue"
                Font-Bold="true"
                BorderColor="Black"
                BorderWidth="1"
                >
                <asp:TableHeaderCell>AlertID</asp:TableHeaderCell>
                <asp:TableHeaderCell>MSID</asp:TableHeaderCell>
                <asp:TableHeaderCell>TimeStamp</asp:TableHeaderCell>
                <asp:TableHeaderCell>Minutes Passed</asp:TableHeaderCell>
                <asp:TableHeaderCell>Trigger After X Mins</asp:TableHeaderCell><%--< 0 is before demurrage has ended, > 0 is after demurrage) how can I word this better?--%>
                <asp:TableHeaderCell>Last Ran</asp:TableHeaderCell>
                <asp:TableHeaderCell>Event ID</asp:TableHeaderCell>
                <asp:TableHeaderCell>Send Alert</asp:TableHeaderCell>
            </asp:TableHeaderRow>
            </asp:Table>

    
    <h2>Drop Trailer Alerts</h2>
        <asp:Table ID="tblDropTrailer" 
            runat="server" 
            Font-Size="Large" 
            Width="1500" 
            Font-Names="Palatino"
            BackColor="LightBlue"
            BorderColor="Black"
            BorderWidth="2"
            ForeColor="Black"
            CellPadding="5"
            CellSpacing="5"
            >
            <asp:TableHeaderRow ID="tblHeaderDropTrailer" 
                runat="server" 
                ForeColor="Black"
                BackColor="LightBlue"
                Font-Bold="true"
                BorderColor="Black"
                BorderWidth="1"
                >
                <asp:TableHeaderCell>AlertID</asp:TableHeaderCell>
                <asp:TableHeaderCell>MSID</asp:TableHeaderCell>
                <asp:TableHeaderCell>TimeStamp</asp:TableHeaderCell>
                <asp:TableHeaderCell>Minutes Passed</asp:TableHeaderCell>
                <asp:TableHeaderCell>Trigger After X Mins</asp:TableHeaderCell>
                <asp:TableHeaderCell>Last Ran</asp:TableHeaderCell>
                <asp:TableHeaderCell>Event ID</asp:TableHeaderCell>
                <asp:TableHeaderCell>Send Alert</asp:TableHeaderCell>
            </asp:TableHeaderRow>
            </asp:Table>
    
    <h2>Tank Capacity Alerts</h2>
        <asp:Table ID="tblTankCapacity" 
            runat="server" 
            Font-Size="Large" 
            Width="1500" 
            Font-Names="Palatino"
            BackColor="LightBlue"
            BorderColor="Black"
            BorderWidth="2"
            ForeColor="Black"
            CellPadding="5"
            CellSpacing="5"
            >
            <asp:TableHeaderRow ID="tblHeaderTankCapacity" 
                runat="server" 
                ForeColor="Black"
                BackColor="LightBlue"
                Font-Bold="true"
                BorderColor="Black"
                BorderWidth="1"
                >
                <asp:TableHeaderCell>Alert ID</asp:TableHeaderCell>
                <asp:TableHeaderCell>Tank ID</asp:TableHeaderCell>
                <asp:TableHeaderCell>Tank Name</asp:TableHeaderCell>
                <asp:TableHeaderCell>Current Capcity</asp:TableHeaderCell>
                <asp:TableHeaderCell>Max Capcity</asp:TableHeaderCell>
                <asp:TableHeaderCell>Alert Percentage</asp:TableHeaderCell>
                <asp:TableHeaderCell>Last Ran</asp:TableHeaderCell>
                <asp:TableHeaderCell>Volume Needed For Trigger</asp:TableHeaderCell>
                <asp:TableHeaderCell>Send Alert</asp:TableHeaderCell>
            </asp:TableHeaderRow>
            </asp:Table>
    <h2>Inactive Alerts</h2>
        <asp:Table ID="tblInactiveTruck" 
            runat="server" 
            Font-Size="Large" 
            Width="1500" 
            Font-Names="Palatino"
            BackColor="LightBlue"
            BorderColor="Black"
            BorderWidth="2"
            ForeColor="Black"
            CellPadding="5"
            CellSpacing="5"
            >
            <asp:TableHeaderRow ID="tblHeaderInactiveTruck" 
                runat="server" 
                ForeColor="Black"
                BackColor="LightBlue"
                Font-Bold="true"
                BorderColor="Black"
                BorderWidth="1"
                >
                <asp:TableHeaderCell>AlertID</asp:TableHeaderCell>
                <asp:TableHeaderCell>MSID</asp:TableHeaderCell>
                <asp:TableHeaderCell>Last Updated</asp:TableHeaderCell>
                <asp:TableHeaderCell>Minutes Passed</asp:TableHeaderCell>
                <asp:TableHeaderCell>Trigger After X Mins</asp:TableHeaderCell>
                <asp:TableHeaderCell>Last Ran</asp:TableHeaderCell>
                <asp:TableHeaderCell>Send Alert</asp:TableHeaderCell>
            </asp:TableHeaderRow>
            </asp:Table>

    <h2>Failed To Upload COFA Alerts</h2>
        <asp:Table ID="tblFailedToUploadCOFATrailer" 
            runat="server" 
            Font-Size="Large" 
            Width="1500" 
            Font-Names="Palatino"
            BackColor="LightBlue"
            BorderColor="Black"
            BorderWidth="2"
            ForeColor="Black"
            CellPadding="5"
            CellSpacing="5"
            >
            <asp:TableHeaderRow ID="tblHeaderFailedToUploadCOFATrailer" 
                runat="server" 
                ForeColor="Black"
                BackColor="LightBlue"
                Font-Bold="true"
                BorderColor="Black"
                BorderWidth="1"
                >
                <asp:TableHeaderCell>AlertID</asp:TableHeaderCell>
                <asp:TableHeaderCell>MSID</asp:TableHeaderCell>
                <asp:TableHeaderCell>TimeStamp</asp:TableHeaderCell>
                <asp:TableHeaderCell>Minutes Passed</asp:TableHeaderCell>
                <asp:TableHeaderCell>Trigger After X Mins</asp:TableHeaderCell>
                <asp:TableHeaderCell>Last Ran</asp:TableHeaderCell>
                <asp:TableHeaderCell>Send Alert</asp:TableHeaderCell>
            </asp:TableHeaderRow>
            </asp:Table>
    <%--hide when not testing--%>
    <%--<div style="display:none; background-color:red">--%>

        <h2>Released Trucks But Order Open In CMS Alerts</h2>
        <asp:Table ID="tblReleasedButOpenInCMS" 
            runat="server" 
            Font-Size="Large" 
            Width="1500" 
            Font-Names="Palatino"
            BackColor="LightBlue"
            BorderColor="Black"
            BorderWidth="2"
            ForeColor="Black"
            CellPadding="5"
            CellSpacing="5"
            >
            <asp:TableHeaderRow ID="tblHeaderReleasedButOpenInCMS" 
                runat="server" 
                ForeColor="Black"
                BackColor="LightBlue"
                Font-Bold="true"
                BorderColor="Black"
                BorderWidth="1"
                >

                <asp:TableHeaderCell>AlertID</asp:TableHeaderCell>
                <asp:TableHeaderCell>MSID</asp:TableHeaderCell>
                <asp:TableHeaderCell>Minutes Passed</asp:TableHeaderCell>
                <asp:TableHeaderCell>Trigger After X Mins</asp:TableHeaderCell>
                <asp:TableHeaderCell>Last Ran</asp:TableHeaderCell>
                <asp:TableHeaderCell>Send Alert</asp:TableHeaderCell>
            </asp:TableHeaderRow>
            </asp:Table>
    <br /><br />
    <div style="background-color:red; display: none;">
                <h3><span id="Span2">Send Test Email<input type="button" onclick="onclick_sendMsg(); return false;" value="Send" /></span></h3>
    </div>
</asp:Content>