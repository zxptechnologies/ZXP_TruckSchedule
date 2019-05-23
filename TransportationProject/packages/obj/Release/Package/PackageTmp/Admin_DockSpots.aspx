<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_DockSpots.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_DockSpots" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Dock Spots</h2>
    <h3>View, add, update, and delete dock spots.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
     <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
         var GLOBAL_GRID_DATA = [];
         var GLOBAL_SPOT_TYPES = [];
         var GLOBAL_SPOTNAME = null;
         var GLOBAL_SPOTID = 0;
         var GLOBAL_DELETEDECISION = 0;
         var GLOBAL_GRID_DATA_PRODUCTS = [];
         var GLOBAL_PRODUCT_ID_OPTIONS = [];
         var GLOBAL_PRODUCT_NAME_OPTIONS = [];
         var FILTERTEXTID = "";
         var FILTERTEXTNAME = "";
         var FILTERTEXT = "";
         var GLOBAL_GRID_EXIST = false;
         
        <%-------------------------------------------------------
        Pagemethods Handlers
        -----------------------------------------------------------%>
         function onSuccess_getDockSpotGridData(value, ctx, methodName) {
             GLOBAL_GRID_DATA.length = [];
             var mins;
             if (value != null) {
                 for (i = 0; i < value.length; i++) {
                     <%--the following: checks gets decial value of duration time and assignes appropriate amount of mins--%>
                     switch ((value[i][2] - Math.floor(value[i][2]))) 
                     {
                         case 0:
                             mins = 00;
                             break;
                         case .25:
                             mins = 15;
                             break;
                         case .5:
                             mins = 30;
                             break;
                         case .75:
                             mins = 45;
                             break;
                     }
                     GLOBAL_GRID_DATA[i] = {
                         "SPOTID": value[i][0], "SPOTTYPE": value[i][3], "SPOTNAME": value[i][1], "BLOCKHOURS": Math.floor(value[i][2]), "BLOCKMINUTES":  mins
                     };
                 }
             }
             if (GLOBAL_GRID_EXIST == false) {
                 initGrid();
             }
             else {
                 //databind
             }
         }
         function onFail_getDockSpotGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_DockSpots.aspx, onFail_getDockSpotGridData");
         }
         function onSuccess_getDockType(value, ctx, methodName) {
             GLOBAL_SPOT_TYPES.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_SPOT_TYPES[i] = { "SPOTTYPES": value[i][0], "SPOTTYPESTEXT": value[i][1] };
             }
             PageMethods.getDockSpotGridData(onSuccess_getDockSpotGridData, onFail_getDockSpotGridData);
         }
         function onFail_getDockType(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_DockSpots.aspx, onFail_getDockType");
         }
        function onSuccess_setNewSpot(value, ctx, methodName) {
             $("#grid").igGridUpdating("setCellValue", ctx, 'SPOTID', value);
             $("#grid").igGrid("commit");
             alert("Please contact Mi4 Corporation to add specific start and end times as well as avaliblity dates");
         }
        function onFail_setNewSpot(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_DockSpots.aspx, onFail_setNewSpot");
         }
         function onSuccess_updateDockSpot(value, ctx, methodName) {
             $("#grid").igGrid("commit");
         }
         function onFail_updateDockSpot(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_DockSpots.aspx, onFail_updateDockSpot");
         }
         function onSuccess_disableDockSpot(value, ctx, methodName) {
             $("#grid").igGridUpdating("deleteRow", GLOBAL_SPOTID);
             $("#grid").igGrid("commit");
             GLOBAL_SPOTID = 0;
             GLOBAL_SPOTNAME = null;
         }
         function onFail_disableDockSpot(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_DockSpots.aspx, onFail_disableDockSpot");
         }
         function onSuccess_perDeleteDockSpot_UpcomingOrderCheck(value, ctx, methodName) {
             if (value == null) {
                 var r = confirm("You are about to delete " + GLOBAL_SPOTNAME + ". This can not be undone. Would you still like to continue deleting " + GLOBAL_SPOTNAME + "?");
                 if (r === true) {
                     PageMethods.disableDockSpot(GLOBAL_SPOTID, onSuccess_disableDockSpot, onFail_disableDockSpot);
                 }
             }
             else {
                 alert("DELETION CANCELLED: There are upcoming orders that are expected to come to this spot. You must update or delete those orders before you can delete the spot.");
                 //var r = confirm("There is an upcoming order expected to be on this spot. You can not undo deleting a spot. Would you like to continue deleting " + GLOBAL_SPOTNAME + "?");
                 //if (r === true) {
                 //    PageMethods.disableDockSpot(GLOBAL_SPOTID, onSuccess_disableDockSpot, onFail_disableDockSpot);
                 //}
             }
                     }
         function onFail_perDeleteDockSpot_UpcomingOrderCheck(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_DockSpots.aspx, onFail_perDeleteDockSpot_UpcomingOrderCheck");
         }
        <%-- Formatters for igGrid & other methods--%>
         function validateDockName(dName, docksObj) {
             for (var i = 0; i < docksObj.length; i++) {
                 if (docksObj[i].SPOTNAME == dName) {
                     return true;
                 }
             }
             return false;
         }
         function formatSpotType(val) {

             var i, sType;
             for (i = 0; i < GLOBAL_SPOT_TYPES.length; i++) {
                 sType = GLOBAL_SPOT_TYPES[i];
                 if (sType.SPOTTYPES === val) {
                     val = sType.SPOTTYPESTEXT;
                 }
             }
             return val; //return val even if not matched
         }


         $(function () {
             PageMethods.getDockType(onSuccess_getDockType, onFail_getDockType);
         }); <%--end $(function () --%>


         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>

         function initGrid() {
             $("#grid").igGrid({
                 dataSource: GLOBAL_GRID_DATA,
                 width: "1500px",
                 virtualization: false,
                 autoGenerateColumns: true,
                 autofitLastColumn: true,
                 renderCheckboxes: true,
                 primaryKey: "SPOTID",
                 columns:
                     [
                         { headerText: " ", key: "SPOTID", dataType: "number", hidden: true ,width:"0px"},
                         { headerText: "Spot Name", key: "SPOTNAME", dataType: "string", width: "675px" },
                         { headerText: "Spot Type", key: "SPOTTYPE", dataType: "string", formatter: formatSpotType, width: "675px" },
                         { headerText: "Hour Duration", key: "BLOCKHOURS", dataType: "number", width: "75px" },
                         { headerText: "Minute Duration", key: "BLOCKMINUTES", dataType: "number", width: "75px" }
                     ],
                 features: [
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
                     },
                     {
                         name: 'Updating',
                         enableAddRow: true,
                         editMode: 'row',
                         enableDeleteRow: true,
                         showReadonlyEditors: false,
                         enableDataDirtyException: false,
                         autoCommit: false,
                         rowDeleting: function (evt, ui) {
                             GLOBAL_SPOTNAME = $("#grid").igGrid("getCellValue", ui.rowID, "SPOTNAME");
                             GLOBAL_SPOTID = ui.rowID;
                             PageMethods.perDeleteDockSpot_UpcomingOrderCheck(GLOBAL_SPOTID, onSuccess_perDeleteDockSpot_UpcomingOrderCheck, onFail_perDeleteDockSpot_UpcomingOrderCheck);

                             return false;
                         },
                         editRowEnding: function (evt, ui) {
                             var origEvent = evt.originalEvent;
                             if (typeof origEvent === "undefined") {
                                 ui.keepEditing = true;
                                 return false;
                             }
                             if ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) {
                                 var spotCount = 0;
                                 if (ui.values.BLOCKHOURS == 24 && ui.values.BLOCKMINUTES != 0) {
                                     alert("Spot time duration can not be greater than 24 hours");
                                     return false;
                                 }
                                 else {
                                     var timeBlock = ui.values.BLOCKHOURS;
                                     <%--the following: checks gets decial value of duration time and assignes appropriate amount of mins--%>
                                     switch (ui.values.BLOCKMINUTES) {
                                         case 15:
                                             timeBlock = timeBlock + .25;
                                             break;
                                         case 30:
                                             timeBlock = timeBlock + .50;
                                             break;
                                         case 45:
                                             timeBlock = timeBlock + .75;
                                             break;
                                     }
                                     for (var i = 0; i < GLOBAL_GRID_DATA.length; i++) {
                                         if (ui.values.SPOTNAME.toLowerCase() == GLOBAL_GRID_DATA[i].SPOTNAME.toLowerCase() && ui.rowID != GLOBAL_GRID_DATA[i].SPOTID) {
                                             alert("There is another spot named " + ui.values.SPOTNAME + ". spot names must be unique");
                                             ui.keepEditing = true;
                                             return false;
                                         }
                                     }

                                     //adding Dock
                                     if (ui.update == true && ui.rowAdding == true) {// && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                                         GLOBAL_SPOTID = ui.values.SPOTID;

                                         PageMethods.setNewSpot(ui.values.SPOTNAME, ui.values.SPOTTYPE, timeBlock, onSuccess_setNewSpot, onFail_setNewSpot, ui.values.SPOTID);
                                     }
                                         //edit Dock
                                     else if (ui.update == true && ui.rowAdding == false) { //&& (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                                         GLOBAL_SPOTID = ui.rowID;
                                         PageMethods.updateDockSpot(ui.rowID, ui.values.SPOTNAME, ui.values.SPOTTYPE, timeBlock, onSuccess_updateDockSpot, onFail_updateDockSpot);
                                     }
                                 }
                             }
                             else {
                                 return false;
                             }

                         },
                         columnSettings:
                             [
                             { columnKey: "SPOTNAME", required: true },
                             { columnKey: "PRODUCT", readOnly: true },
                                {
                                    columnKey: "SPOTTYPE",
                                    
                                    editorType: "combo",
                                    required: true,
                                    editorOptions: {
                                        mode: "editable",
                                        enableClearButton: false,
                                        dataSource: GLOBAL_SPOT_TYPES,
                                        id: "cboxTruckType",
                                        textKey: "SPOTTYPESTEXT",
                                        valueKey: "SPOTTYPES",
                                        autoSelectFirstMatch: true
                                    }
                                },
                                 {
                                     columnKey: "BLOCKHOURS",
                                     editorType: "numeric",
                                     mode:'dropdown',
                                     required: true,
                                     editorOptions: {
                                         dataMode: "int",
                                         maxDecimals: 0,
                                         button: 'spin',
                                         enableClearButton: false,
                                         minValue: 0,
                                         maxValue: 24,
                                         required: true,
                                     }
                                 }, 
                                 {
                                     columnKey: "BLOCKMINUTES",
                                     editorType: "numeric",
                                     required: true,
                                     editorOptions: {
                                         dataMode: "int",
                                         maxDecimals: 0,
                                         button: 'spin',
                                         readOnly: true,
                                         spinOnReadOnly : true,
                                         spinWrapAround: true,
                                         listMatchOnly : true,
                                         enableClearButton: false,
                                         minValue: 00,
                                         maxValue: 45,
                                         spinDelta: 15,
                                         required: true,
                                         autoSelectFirstMatch: true,
                                     }
                                 }
                             ]
                     }

                 ]

             }); <%--end of $("#grid").igGrid({--%>
             GLOBAL_GRID_EXIST = true;
             $("#gridProductsWrapper").hide();
        }// end of initgrid()
    </script>
    
    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
        <br />
        <br />
    <div> <table id="grid"></table> </div>
    
    <div id="gridProductsWrapper">
        <button type="button" id="button_BackToDockSpots" onclick='onClick_BackToDockSpots();'>Back To Dock Spots</button>
        <table id="gridProducts"></table>
    </div>

</asp:Content>