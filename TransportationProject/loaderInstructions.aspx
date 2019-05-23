<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="loaderInstructions.aspx.cs" Inherits="TransportationProject.loaderInstructions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Loader Request</h2>
    <h3>Shows open loader requests and all completed requests for the day. </h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
     <%--TODO: need to fix Time Tracking button--%>
     <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
         var data = [];
         data.length = 0;


         <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>
        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>

         function onSuccess_getLoaderPO(value, ctx, methodName) {
             var newLoaderInstructionData = [];   <%--values to bind grid--%>
             newLoaderInstructionData.length = 0 <%--make empty--%>

             for (i = 0; i < value.length; i++) {
                 <%--creates inspection button--%>
                 var inspection = [];
                 inspection.push("<input class ='ColumnContentExtend' type='button' data-ajax=\"false\" value = \"", value[i][1], "\"onclick='onClick_InstructionButtons(", value[i][0], ",\"", value[i][1], "\"", ");' />");
                 inspection = inspection.join("");

                 <%--creates load/unload pattern button--%>
                 var pattern = [];
                 if (value[i][1] == "Inbound") {
                     pattern.push("<input class ='ColumnContentExtend' type='button' data-ajax=\"false\" value = \"Unload Pattern\"onclick='onClick_InstructionButtons(", value[i][0], ",\"Unload\");' />");
                 }
                 else if (value[i][1] == "Outbound") {
                     pattern.push("<input class ='ColumnContentExtend' type='button' data-ajax=\"false\" value = \"Load Pattern\"onclick='onClick_InstructionButtons(", value[i][0], ",\"Load\");' />");

                 }
                 pattern = pattern.join("");

                 <%--load data--%>
                 newLoaderInstructionData[i] = { "PO": value[i][0], "INSPECTION": inspection, "PATTERN": pattern };
             }
             $("#grid").igGrid("option", "dataSource", newLoaderInstructionData);
             $("#grid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>

         }
         function onFail_getLoaderPO(value, ctx, methodName) {
             alert("getLoaderPO failed");
         }


        <%-------------------------------------------------------
         Button Click Handlers
         -------------------------------------------------------%>
         function onClick_InstructionButtons(POnum, buttonPressed) {

             switch (buttonPressed) {
                 case "Inbound":
                     window.location.replace("inspection.aspx?PO=" + POnum + "&InspectionType=Inbound");
                     break;
                 case "Outbound":
                     window.location.replace("inspection.aspx?PO=" + POnum + "&InspectionType=Outbound");
                     break;
                 case "Unload":
                     window.location.replace("patternList.aspx?PO=" + POnum + "&PatternType=Unload");
                     break;
                 case "Load":
                     window.location.replace("patternList.aspx?PO=" + POnum + "&PatternType=Load");
                     break;
             }
         }
         
         function onClick_goToTimeTracking() {
             window.location = "loaderTimeTracking.aspx";
         }
         
         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
         $(function () {
             $("#grid").igGrid({
                 dataSource: data,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 renderCheckboxes: true,
                 primaryKey: "PO",
                 columns:
                     [
                         { headerText: "PO", key: "PO", dataType: "number" },
                         { headerText: "Inspection", key: "INSPECTION", dataType: "string"},
                         { headerText: "Pattern", key: "PATTERN", dataType: "string" }
                     ],
                 rowsRendered: function (evt, ui) {
                     <%--centers pattern and inspection buttons--%>
                    // $("#" + ui.owner.id() + ">tbody:eq(0)").children('tr').children('td:nth-child(' + 2 + ')').css("text-align", "center");
                   //  $("#" + ui.owner.id() + ">tbody:eq(0)").children('tr').children('td:nth-child(' + 3 + ')').css("text-align", "center");
                 },
                 features: [
                     {
                         name: 'Paging'
                     },
                     {
                         name: 'Resizing'
                     },
                     {
                           name: "Filtering",
                           allowFiltering: true,
                           caseSensitive: false
                       },
                       {
                           name: 'Sorting'
                       }
                 ]

             }); <%--end of $("#grid").igGrid({--%>
             PageMethods.getLoaderPO(onSuccess_getLoaderPO, onFail_getLoaderPO);

         });<%--end of $(function () {--%>



     </script>
    
    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <table id="grid"></table>
    <div class="loaderToggle">
        <input type='button' value = 'Time Tracking' onclick="onClick_goToTimeTracking()"/>
    </div>
</asp:Content>