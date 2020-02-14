
<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="guardStation.aspx.cs" Inherits="TransportationProject.Scripts.guardStation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Content/InspectionsPageStyle.css" rel="stylesheet" />
    <%--<link href="Content/ElementExpansion.css" rel="stylesheet" />--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Guard's Station</h2>
    <h3>Check and weigh in/out trucks and trailers. Shows all incoming and outgoing truck orders.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
 
     <script type="text/javascript">
         <%--Globals--%>
         var GLOBAL_STATUS_OPTIONS = [];
         var GLOBAL_STATUSFORMAT_OPTIONS = [];
         var GLOBAL_LOCATION_OPTIONS = [];
         var GLOBAL_GRID_DATA = [];
         var GLOBAL_LOG_OPTIONS = [];
         var GLOBAL_SPOTS_OPTIONS = [];
         var GLOBAL_UNDO_LOC_OPTIONS = [];

         <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>
         <%--used to find PO when MSID is provided, primary used to check status (client side) befor 'undo'--%>
         function findDatasetFromMSID(MSID) {
             for (var index = 0; index < GLOBAL_GRID_DATA.length; index++) {
                 if (GLOBAL_GRID_DATA[index].MSID == MSID) {
                     return index;
                 }
             }
         }
             
         function LaunchTruckWeightApp(Weightstring) {                       
             var MSID = $("#weightDialogBox").data("data-MSID");
         
             var WeightAppPath = '<%=ConfigurationManager.AppSettings["weightAppPath"] %>';
             
             $("#WeightAppTag").attr('onclick', "window.open('"+WeightAppPath+" "+ Weightstring + "')");
             $("#WeightAppTag").click();                                
         }      

         function toggleDisplayItem(itemName) {
            // var isVisible = $('#' + itemName + ':visible');
            var isVisible = $('#' + itemName).is(":visible");
            if (isVisible) {
                $("#" + itemName).hide();
            }
            else {
                $("#" + itemName).show();
            }
         }

         <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>

         function onSuccess_checkIfCanUpdateTrailerNumber(canUpdateTrailer, contextParam, methodName) {
             if (canUpdateTrailer == false) {
                 PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
                 alert("Can not update trailer number because there is another trailer with the same number in the facility.");
             }
             else {
                 //var MSID = $("#grid").data("data-MSID");
                 var MSID = contextParam["MSID"];
                 var trailerNumber = contextParam["TrailerNum"];
                 PageMethods.updateRowData(MSID, trailerNumber, null, null, null, onSuccess_updateRowData, onFail_updateRowData);
             }
         }


         function onFail_checkIfCanUpdateTrailerNumber(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkIfCanUpdateTrailerNumber");
         }

         function onSuccess_GetPODetailsFromMSID(value, ctx, methodName) {
             var gridData = [];
             for (i = 0; i < value.length; i++) {
                 gridData[i] = {
                     "PODETAILID": value[i][0], "CMSPROD": value[i][1], "QTY": value[i][2], "LOT": value[i][3], "UNIT": value[i][4], "CMSPRODNAME": value[i][5]
                 };
             }
             $("#gridPODetails").igGrid("option", "dataSource", gridData);
             $("#gridPODetails").igGrid("dataBind");
             $("#dwProductDetails").igDialog("open");

         }
         function onFail_GetPODetailsFromMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_GetPODetailsFromMSID");
         }
         function onSuccess_verifySpotIsCurrentlyAvailable(NumberOfTrucksScheduledInTimeBlock, ctx, methodName) {
             var MSID = $("#undoCheckOutLocationDialogBox").data("data-MSID");
             var dSpotID = $("#cboxDockSpots").igCombo("value");
             var dSpotName = $("#cboxDockSpots").igCombo("text");
             if (NumberOfTrucksScheduledInTimeBlock > 0) {
                 alert("There is a truck currently in dock spot " + dSpotName + ". Please pick a new location and try again.");
             }
             else {
                 PageMethods.verifySpotIsAvailableInSchedule(MSID, dSpotID, onSuccess_verifySpotIsAvailableInSchedule, onFail_verifySpotIsAvailableInSchedule, MSID);
             }

         }
         function onFail_verifySpotIsCurrentlyAvailable(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_verifySpotIsCurrentlyAvailable");
         }


         function onSuccess_verifySpotIsAvailableInSchedule(returnData, MSID, methodName) {
             var MSID = $("#undoCheckOutLocationDialogBox").data("data-MSID");
             var newLocation = $("#cboxLocations").igCombo("value");
             var dSpot = $("#cboxDockSpots").igCombo("value");

             if (!checkNullOrUndefined(returnData)) {

                 if (returnData[0][4] == 'Not On Site') {

                     var c = confirm("The PO " + returnData[0][0] + " with trailer # " + returnData[0][1] + "is expected to arrive at " + formatDate(returnData[0][2]) + " and has the dock spot reserved till " + formatDate(returnData[0][3]) + ". Would you like to continue?");

                     if (c == true) {
                         PageMethods.updateLocationAndUndoCheckOut(MSID, newLocation, dSpot, onSuccess_updateLocationAndUndoCheckOut, onFail_updateLocationAndUndoCheckOut, MSID);
                     }
                 }
                 else {
                     var c = confirm("The PO " + returnData[0][0] + " with trailer # " + returnData[0][1] + " has the dock spot reserved from " + formatDate(returnData[0][2]) + " to " + formatDate(returnData[0][3]) + ". It is currently on site at " + returnData[0][4] + " with a status of " + returnData[0][5] + ". Would you like to continue?");

                     if (c == true) {
                         PageMethods.updateLocationAndUndoCheckOut(MSID, newLocation, dSpot, onSuccess_updateLocationAndUndoCheckOut, onFail_updateLocationAndUndoCheckOut, MSID);
                     }
                 }
             }
             else {
                 PageMethods.updateLocationAndUndoCheckOut(MSID, newLocation, dSpot, onSuccess_updateLocationAndUndoCheckOut, onFail_updateLocationAndUndoCheckOut, MSID);
             }

         }
         function onFail_verifySpotIsAvailableInSchedule(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_verifySpotIsAvailableInSchedule");
         }

         function onSuccess_updateLocationAndUndoCheckOut(value, MSIDofSelectedTruck, methodName) {
             //PageMethods.GetLogDataByMSID(MSIDofSelectedTruck, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSIDofSelectedTruck);
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
             $("#undoCheckOutLocationDialogBox").igDialog("close");
         }

         function onFail_updateLocationAndUndoCheckOut(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_updateLocationAndUndoCheckOut");
         }

         function onSuccess_checkIfTrailerDropped(hasBeenDropped, MSID, methodName) {
             var Trailer = $("#grid").igGrid("getCellValue", MSID, "TRAILER");
             var PO = $("#grid").igGrid("getCellValue", MSID, "PO");
             if (hasBeenDropped == true) {
                 c = confirm("You are about to check out PO # " + PO + " with trailer # " + Trailer + ". The out going cab must include the trailer. Click Cancel if trailer is not leaving or Ok to continue checking out.");
                 if (c == true) {
                     $("#grid").data("data-MSID", MSID);
                     PageMethods.CheckCurrentStatus(MSID, onSuccess_CheckCurrentStatus_CheckInCheckOutAndUndos, onFail_CheckCurrentStatus, "Out");
                     //PageMethods.checkOut(MSID, onSuccess_checkOut, onFail_checkOut);
                 }
             }
             else {
                 c = confirm("Records show that PO # " + PO + " has a trailer (trailer # " + Trailer + ") that has not been dropped. The out going cab must include the trailer. Click Cancel if trailer is not leaving or Ok to continue checking out.");
                 if (c == true) {
                     $("#grid").data("data-MSID", MSID);
                     PageMethods.CheckCurrentStatus(MSID, onSuccess_CheckCurrentStatus_CheckInCheckOutAndUndos, onFail_CheckCurrentStatus, "Out");
                     //PageMethods.checkOut(MSID, onSuccess_checkOut, onFail_checkOut);
                 }
             }
         }

         function onSuccess_checkIfTrailerDropped_WeightsDisplay(hasDropped, MSID, methodName) {
             $("#weightDialogBox").data("data-hasTrailerDropped", hasDropped);
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights, onFail_getCurrentWeights, MSID);
         }


         function onFail_checkIfTrailerDropped(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkIfTrailerDropped");
         }

         function onSuccess_getAvailableDockSpots(value, MSID, methodName) {
             GLOBAL_SPOTS_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_SPOTS_OPTIONS[i] = { "SPOTID": value[i][0], "DOCKSPOT": value[i][1] };
             }
             $("#cboxDockSpots").igCombo("option", "dataSource", GLOBAL_SPOTS_OPTIONS);
             $("#cboxDockSpots").igCombo("dataBind");

             $("#dockSpotOptionsWrapper").hide();
             $("#undoCheckOutLocationDialogBox").igDialog("open");
         }

         function onFail_getAvailableDockSpots(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_getAvailableDockSpots");
         }

         function onSuccess_getUndoLocationOptions(returnValue, MSID, methodName) {
             GLOBAL_UNDO_LOC_OPTIONS = [];

             for (i = 1; i < returnValue.length; i++) {<%--start at one to not add current location--%>
                 GLOBAL_UNDO_LOC_OPTIONS.push({ "LOC": returnValue[i][0], "LOCTEXT": returnValue[i][1] });
             }

             $("#cboxLocations").igCombo("option", "dataSource", GLOBAL_UNDO_LOC_OPTIONS);
             $("#cboxLocations").igCombo("dataBind");

             PageMethods.getAvailableDockSpots(MSID, onSuccess_getAvailableDockSpots, onFail_getAvailableDockSpots, MSID);
         }

         function onFail_getUndoLocationOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getUndoLocationOptions");
         }

         <%--Grid Data--%>
         function onSuccess_getGuardStationGridData(value, ctx, methodName) {
             GLOBAL_GRID_DATA = []; <%--make empty--%>
             for (i = 0; i < value.length; i++) {
                 <%--DocumentVerificationTS returns a time stamp there for if there is no time stamp, the document hasnt been verified --%>
                 var isDropTrailer;
                 isDropTrailer = formatBoolAsYesOrNO(value[i][19]);
                 var isOpenInCMS;
                 isOpenInCMS = formatBoolAsYesOrNO(value[i][21]);

                 var prodCount = value[i][24];
                 var prodDetail = prodCount < 2 ? value[i][26] : "multiple";
                 var prodID = prodCount < 2 ? value[i][25] : "multiple";


                 GLOBAL_GRID_DATA[i] = {
                     "MSID": value[i][1], "MSIDTEXT": value[i][1], "PO": value[i][0], "POTEXT": value[i][0], "COMMENTS": value[i][2], "ETA": value[i][3], "DOCVERI": value[i][4],
                     "CHECKIN": value[i][5], "CHECKOUT": value[i][6], "TRAILER": value[i][7], "CAB1NUM": value[i][8], "CAB2NUM": value[i][9],
                     "REJECTED": value[i][10], "BLANKETPORELEASENUMBER": value[i][11], "DRIVERNAME": value[i][12], "DRIVERPHONENUMBER": value[i][13],
                     "STATUS": value[i][14], "LOCATION": value[i][15], "TRUCKTYPE": value[i][16], "LOADTYPESHORT": value[i][17], "DOCKSPOT": value[i][18],
                     "isDROPTRAILER": isDropTrailer, "CARRIERINFO": value[i][20], "isOpenInCMS": isOpenInCMS, "LOADTYPE": value[i][22], "TRUCKTYPELONG": value[i][23],
                     "BoolIsOpenInCMS": value[i][21], "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail, "ZXPPONUM": value[i][27]
                 };
             }

             initGrid();
         }
         function onSuccess_getGuardStationGridDataRebind(value, ctx, methodName) {
             GLOBAL_GRID_DATA = []; <%--make empty--%>
             for (i = 0; i < value.length; i++) {
                 <%--DocumentVerificationTS returns a time stamp there for if there is no time stamp, the document hasnt been verified --%>
                 var isDropTrailer;
                 isDropTrailer = formatBoolAsYesOrNO(value[i][19]);
                 var isOpenInCMS;
                 isOpenInCMS = formatBoolAsYesOrNO(value[i][21]);
                 var prodCount = value[i][24];
                 var prodDetail = prodCount < 2 ? value[i][26] : "multiple";
                 var prodID = prodCount < 2 ? value[i][25] : "multiple";

                 GLOBAL_GRID_DATA[i] = {
                     "MSID": value[i][1], "MSIDTEXT": value[i][1], "PO": value[i][0], "POTEXT": value[i][0], "COMMENTS": value[i][2], "ETA": value[i][3], "DOCVERI": value[i][4],
                     "CHECKIN": value[i][5], "CHECKOUT": value[i][6], "TRAILER": value[i][7], "CAB1NUM": value[i][8], "CAB2NUM": value[i][9],
                     "REJECTED": value[i][10], "BLANKETPORELEASENUMBER": value[i][11], "DRIVERNAME": value[i][12], "DRIVERPHONENUMBER": value[i][13],
                     "STATUS": value[i][14], "LOCATION": value[i][15], "TRUCKTYPE": value[i][16], "LOADTYPESHORT": value[i][17], "DOCKSPOT": value[i][18],
                     "isDROPTRAILER": isDropTrailer, "CARRIERINFO": value[i][20], "isOpenInCMS": isOpenInCMS, "LOADTYPE": value[i][22], "TRUCKTYPELONG": value[i][23],
                     "BoolIsOpenInCMS": value[i][21], "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail, "ZXPPONUM": value[i][27]
                 };
             }
             $("#undoCheckOutLocationDialogBox").igDialog("close");

             $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
             $("#grid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
         }
         function onFail_getGuardStationGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getGuardStationGridData");
         }

         function onSuccess_GetStatusOptions(value, ctx, methodName) {
             GLOBAL_STATUS_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 //GLOBAL_STATUS_OPTIONS[i] = { "STATUS": value[i][0], "STATUSTEXT": value[i][1] };
                GLOBAL_STATUS_OPTIONS[i] = { "STATUS": value[i]["StatusID"], "STATUSTEXT": value[i]["StatusText"] };
             }
             PageMethods.GetLocationOptions(onSuccess_GetLocationOptions, onFail_GetLocationOptions);
         }

         function onFail_GetStatusOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_GetStatusOptions");
         }

         function onSuccess_GetLocationOptions(value, ctx, methodName) {
             GLOBAL_LOCATION_OPTIONS = [];
             for (i = 0; i < value.length; i++) {
                // GLOBAL_LOCATION_OPTIONS[i] = { "LOCATION": value[i][0], "LOCATIONTEXT": value[i][1] };
                 GLOBAL_LOCATION_OPTIONS[i] = { "LOCATION": value[i]["LocationShort"], "LOCATIONTEXT": value[i]["LocationLong"] };
             }
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridData, onFail_getGuardStationGridData);
         }

         function onFail_GetLocationOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_GetLocationOptions");
         }

         function onSuccess_launchAppAndUpdateWeight(weightValues, MSID, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             LaunchTruckWeightApp(weightValues);
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }
         function onFail_launchAppAndUpdateWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_launchAppAndUpdateWeight");
         }

         function onSuccess_checkAndUpdateWeights(weightValues, ctx, methodName) {
             var buttonPressed = $("#weightDialogBox").data("data-ButtonPressed");
             popWeightDialogBoxWeights(weightValues);
             restoreToCorrectWeightDisplayAfterRepop(buttonPressed);
         }
         function onFail_checkAndUpdateWeights(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkAndUpdateWeights");
         }
         function onSuccess_checkIn(value, MSID, methodName) {
             hideProgress();
             var gMSID = $("#grid").data("data-MSID");
             var StatusID = $("#grid").data("data-StatusID");
             onclick_OpenMoreDetails(StatusID, gMSID, false, false);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);

         }
         function onFail_checkIn(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkIn");
         }
         function onSuccess_checkOut(value, ctx, methodName) {
             hideProgress();
             var MSID = $("#grid").data("data-MSID");
             var StatusID = $("#grid").data("data-StatusID");
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
         }
         function onFail_checkOut(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkOut");
         }
         function onSuccess_undoCheckIn(returnMessage, MSID, methodName) {
             if (!checkNullOrUndefined(returnMessage)) {
                 if (returnMessage[0] == 'true') {
                     //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
                     PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
                 }
                 else {
                     alert(returnMessage[1]);
                 }
             }
             else {
                 alert("The application has encountered an error. Please refresh the page and try to undo check in again.");
             }
         }
         function onFail_undoCheckIn(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoCheckIn");
         }
         function onSuccess_undoCheckOut(returnMessage, MSID, methodName) {
             if (!checkNullOrUndefined(returnMessage)) {
                 if (returnMessage[0] == 'true') {
                     //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
                     PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
                 }
                 else {
                     alert(returnMessage[1]);
                 }
             }
             else {
                 alert("The application has encountered an error. Please refresh the page and try to undo check out again.");
             }
         }
         function onFail_undoCheckOut(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoCheckOut");
         }

         function onSuccess_calculateWeight(returnValue, weightData, methodName) {
             var weightValues = returnValue[1];
             if (!checkNullOrUndefined(returnValue[0])) {
                 alert(returnValue[0]);
             }
             else {
                 var MSID = $("#weightDialogBox").data("data-MSID");
                 PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
             }

         }
         function onFail_calculateWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_calculateWeight");
         }

         function onSuccess_updateWeightManually(weightValues, weightData, methodName) {
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);

             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }
         function onFail_updateWeightManually(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_updateWeightManually");
         }

         function onSuccess_updateRowData(returnMessage, ctx, methodName) {
             if (returnMessage != "success") {
                 alert(returnMessage);
             }
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);

         }
         function onFail_updateRowData(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_updateRowData");
         }

         function onSuccess_setVerify(value, ctx, methodName) {
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);

         }
         function onFail_setVerify(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_setVerify");
         }

         function onSuccess_undoVerify(value, ctx, methodName) {
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);

         }

         function onFail_undoVerify(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoVerify");
         }

         function onSuccess_GetLogDataByMSID(returnValue, MSID, methodName) {
             truckLog_OnSuccess_Render(returnValue, MSID);
         }

         function onFail_GetLogDataByMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_GetLogDataByMSID");
         }


         function onSuccess_checkIfManualEntryIsEnabled(value, net, methodName) {
             if (value) {
                 $("#btnInManualGrossWeight").prop("disabled", false);
                 $("#btnInManualCab1Weight").prop("disabled", false);
                 $("#btnInManualCab1wTrailerWeight").prop("disabled", false);
                 $("#btnInManualCab2Weight").prop("disabled", false);
                 $("#btnOutManualCab1Weight").prop("disabled", false);
                 $("#btnOutManualCab1wTrailerWeight").prop("disabled", false);
                 $("#btnOutManualGrossWeight").prop("disabled", false);
                 $("#btnOutManualCab2wTrailerWeight").prop("disabled", false);
                 $("#btnManualTrailerWeight").prop("disabled", false);
             }
             else {
                 $("#btnInManualGrossWeight").prop("disabled", true);
                 $("#btnInManualCab1Weight").prop("disabled", true);
                 $("#btnInManualCab1wTrailerWeight").prop("disabled", true);
                 $("#btnInManualCab2Weight").prop("disabled", true);
                 $("#btnOutManualCab1Weight").prop("disabled", true);
                 $("#btnOutManualCab1wTrailerWeight").prop("disabled", true);
                 $("#btnOutManualGrossWeight").prop("disabled", true);
                 $("#btnOutManualCab2wTrailerWeight").prop("disabled", true);
                 $("#btnManualTrailerWeight").prop("disabled", true);
             }

             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.CheckCurrentStatus(MSID, onSuccess_CheckCurrentStatus_OpenWeightDialog, onFail_CheckCurrentStatus, net);
         }

         function onFail_checkIfManualEntryIsEnabled(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_checkIfManualEntryIsEnabled");
         }


         function onSuccess_GetLogList(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     var POTrailerCombo = comboPOAndTrailer(value[i][1], value[i][2]);

                     GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailerCombo });
                 }
                 $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                 $("#cboxLogTruckList").igCombo("dataBind");
             }
         }
         function onFail_GetLogList(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_GetLogList");
         }
         function onSuccess_isTruckAllowedToCheckOut(value, ctx, methodName) {
            var isAllowed = value[0];
            var errorMsg = value[1];

            var response = true;
            if (!isAllowed) {
                alert("Cannot check out the truck. Please make sure that the issues are solved: " + errorMsg);
            }
            else 
            {
                var MSID = $("#grid").data("data-MSID");
                onclick_OpenMoreDetails(StatusID, MSID, true, false);
                //PageMethods.checkOut(MSID, onSuccess_checkOut, onFail_checkOut, MSID);
            }
            
         }
         function onFail_isTruckAllowedToCheckOut(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_isTruckAllowedToCheckOut");
         }

         function onSuccess_CheckCurrentStatus_CheckInCheckOutAndUndos(currentStatus, actionAttempted, methodName) {
             var MSID = $("#grid").data("data-MSID");
             if (currentStatus == "NOS" && actionAttempted == "Out") {
                 alert("This truck has already been checked out. Please refresh the page for the lastest data.");
                 return;
             }
             else if (currentStatus != "NOS" && actionAttempted == "In") {
                 alert("This truck has already been checked in. Please refresh the page for the lastest data.");
                 return;
             }
             else if (currentStatus != "NOS" && actionAttempted == "Out") {
                 PageMethods.isTruckAllowedToCheckOut(MSID, onSuccess_isTruckAllowedToCheckOut, onFail_isTruckAllowedToCheckOut);
             }
             else if (currentStatus == "NOS" && actionAttempted == "In") {
                 showProgress();
                 PageMethods.checkIn(MSID, onSuccess_checkIn, onFail_checkIn, MSID);
             }
                 //undos
             else if (currentStatus != "NOS" && actionAttempted == "uOut") {
                 alert("Undo check out has been done for this truck. Please refresh the page for the lastest data.");
             }
             else if (currentStatus == "NOS" && actionAttempted == "uOut") {
                 PageMethods.undoCheckOut(MSID, onSuccess_undoCheckOut, onFail_undoCheckOut, MSID);
             }
             else if (currentStatus == "NOS" && actionAttempted == "uIn") {
                 alert("Undo check in has been done for this truck. Please refresh the page for the lastest data.");
             }
             else if (currentStatus != "NOS" && actionAttempted == "uIn") {
                 PageMethods.undoCheckIn(MSID, onSuccess_undoCheckIn, onFail_undoCheckIn, MSID);
             }
         }
         function onSuccess_CheckCurrentStatus_OpenWeightDialog(currentStatus, ctx, methodName) {
             var buttonPressed = $("#weightDialogBox").data("data-ButtonPressed");
             $("#weightOptionsIn").hide();
             $("#weightOptionsOut").hide();
             $("#weightOptionsTrailer").hide();
             if (currentStatus == "NOS") {
                 $("#weightDialogBox").data("data-NOS", true);
                 <%--hide all buttons since weight cant be updated--%>
                 //console buttons
                 $("#btnInGrossWeight").hide();
                 $("#btnInCab1Weight").hide();
                 $("#btnInCab1wTrailerWeight").hide();
                 $("#btnInCab2Weight").hide();
                 $("#btnOutCab1Weight").hide();
                 $("#btnOutCab1wTrailerWeight").hide();
                 $("#btnOutGrossWeight").hide();
                 $("#btnOutCab2wTrailerWeight").hide();
                 $("#btnTrailerWeight").hide();


                 //undo buttons
                 $("#undoInGrossWeight").hide();
                 $("#undoInCab1Weight").hide();
                 $("#undoInCab1wTrailerWeight").hide();
                 $("#undoCab2wTrailerWeight").hide();
                 $("#undoInCab2Weight").hide();
                 $("#undoOutCab1Weight").hide();
                 $("#undoOutCab1wTrailerWeight").hide();
                 $("#undoOutGrossWeight").hide();
                 $("#undoOutCab2wTrailerWeight").hide();
                 $("#undoTrailerWeight").hide();

                 //manual buttons
                 $("#btnInManualGrossWeight").hide();
                 $("#btnInManualCab1Weight").hide();
                 $("#btnInManualCab1wTrailerWeight").hide();
                 $("#btnInManualCab2Weight").hide();
                 $("#btnOutManualCab1Weight").hide();
                 $("#btnOutManualCab1wTrailerWeight").hide();
                 $("#btnOutManualGrossWeight").hide();
                 $("#btnOutManualCab2wTrailerWeight").hide();
                 $("#btnManualTrailerWeight").hide();

                 //calc buttons
                 $("#btnInCalCab1").hide();
                 $("#btnInCalCab1wTrailer").hide();
                 $("#btnInCalCab2").hide();
                 $("#btnOutCalCab1").hide();
                 $("#btnCalNet").hide();
                 $("#btnOutCalCab1wTrailer").hide();
                 $("#btnOutCalCab2wTrailer").hide();
                 $("#btnCalcTrailer").hide();

                 alert("Truck is no longer on site and weights can not be updated.");
             }
             else {
                 restoreToCorrectWeightDisplayAfterRepop(buttonPressed);
                 $("#weightDialogBox").data("data-NOS", false);
             }

             $("#weightDialogBox").igDialog("open");
             $("#btnCalcNet").html("Recalculate Net");
             //$("#lblNetWeight").html(NetVal);
         }
         function onFail_CheckCurrentStatus(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_CheckCurrentStatus");
         }

         function onSuccess_updateDriverInfo(value, arrayDriverInfo, methodName) {
             var MSID = $("#MoreDetailsDialog").data("data-MSID");

             var index = searchDataSourceByMSID(MSID);

             GLOBAL_GRID_DATA[index].DRIVERNAME = arrayDriverInfo[0];
             GLOBAL_GRID_DATA[index].DRIVERPHONENUMBER = arrayDriverInfo[1];
             GLOBAL_GRID_DATA[index].CAB1NUM = arrayDriverInfo[3];
             GLOBAL_GRID_DATA[index].TRAILER  = arrayDriverInfo[4];
             
             $("#saveDriverInfoText").css("display", "block");
             $("#saveDriverInfoText").fadeOut(3000);

             
             var isCheckOut = $("#MoreDetailsDialog").data("data-isCheckOut");
             if (isCheckOut) {
                PageMethods.checkOut(MSID, onSuccess_checkOut, onFail_checkOut, MSID);
             }

             onClick_CloseMoreDetails();
             
         }
         function onFail_updateDriverInfo(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_updateDriverInfo");
         }

         function onSuccess_updateGSCommentAndCabNumbers(value, ctx, methodName) {
             var MSID = $("#detailsDialog").data("data-MSID");
             var GSComment = $("#txtAreaGSComment").val();
             var cab1 = $("#txtCab1DetailsDialog").val();
             var cab2 = $("#txtCab2DetailsDialog").val();
             var index = searchDataSourceByMSID(MSID);

             GLOBAL_GRID_DATA[index].COMMENTS = GSComment;
             GLOBAL_GRID_DATA[index].CAB1NUM = cab1;
             GLOBAL_GRID_DATA[index].CAB2NUM = cab2;

             $("#saveGSComment").css("display", "block");
             $("#saveGSComment").fadeOut(3000);
         }
         function onFail_updateGSCommentAndCabNumbers(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_updateGSCommentAndCabNumbers");
         }
         function onSuccess_getCurrentWeights_RePop(weightValues, MSID, methodName) {
             var buttonPressed = $("#weightDialogBox").data("data-ButtonPressed");
             $("#weightDialogBox").data("data-grossWeight", weightValues[0]);
             $("#weightDialogBox").data("data-cab1SoloWeight", weightValues[1]);
             $("#weightDialogBox").data("data-cab2SoloWeight", weightValues[2]);
             $("#weightDialogBox").data("data-cab2WithTrailerWeight", weightValues[3]);
             $("#weightDialogBox").data("data-trailerWeight", weightValues[4]);
             $("#weightDialogBox").data("data-netWeight", weightValues[5]);
             $("#weightDialogBox").data("data-cab1WithTrailerWeight", weightValues[11]);

             $("#weightDialogBox").data("data-grossWeightMethod", weightValues[6]);
             $("#weightDialogBox").data("data-cab1SoloWeightMethod", weightValues[7]);
             $("#weightDialogBox").data("data-cab2SoloWeightMethod", weightValues[8]);
             $("#weightDialogBox").data("data-cab2WithTrailerWeightMethod", weightValues[9]);
             $("#weightDialogBox").data("data-trailerWeightMethod", weightValues[10]);
             $("#weightDialogBox").data("data-cab1WithTrailerWeightMethod", weightValues[12]);
             popWeightDialogBoxWeights(weightValues);
             restoreToCorrectWeightDisplayAfterRepop(buttonPressed);
         }

         function onSuccess_getCurrentWeights(weightValues, MSID, methodName) {
             $("#weightDialogBox").data("data-MSID", MSID);
             var headerString = "";
             var trailer = "";
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = GLOBAL_GRID_DATA[index].isDROPTRAILER;
             var loadType = GLOBAL_GRID_DATA[index].LOADTYPE;
             $("#weightDialogBox").data("data-isDropTrailer", isDropTrailer);
             $("#weightDialogBox").data("data-loadType", loadType);

             if (GLOBAL_GRID_DATA[index].TRAILER != null) {
                 trailer = GLOBAL_GRID_DATA[index].TRAILER;
             }
             headerString = "Weights associated with PO# " + GLOBAL_GRID_DATA[index].PO + " Trailer# " + trailer;
             $("#weightDialogBox").igDialog("option", "headerText", headerString);


             $("#weightDialogBox").data("data-grossWeight", weightValues[0]);
             $("#weightDialogBox").data("data-cab1SoloWeight", weightValues[1]);
             $("#weightDialogBox").data("data-cab2SoloWeight", weightValues[2]);
             $("#weightDialogBox").data("data-cab2WithTrailerWeight", weightValues[3]);
             $("#weightDialogBox").data("data-trailerWeight", weightValues[4]);
             $("#weightDialogBox").data("data-netWeight", weightValues[5]);
             $("#weightDialogBox").data("data-cab1WithTrailerWeight", weightValues[11]);

             $("#weightDialogBox").data("data-grossWeightMethod", weightValues[6]);
             $("#weightDialogBox").data("data-cab1SoloWeightMethod", weightValues[7]);
             $("#weightDialogBox").data("data-cab2SoloWeightMethod", weightValues[8]);
             $("#weightDialogBox").data("data-cab2WithTrailerWeightMethod", weightValues[9]);
             $("#weightDialogBox").data("data-trailerWeightMethod", weightValues[10]);
             $("#weightDialogBox").data("data-cab1WithTrailerWeightMethod", weightValues[12]);

             if (isDropTrailer == "Yes" || loadType == "Load Out") {
                 $("#WeighTrailerOnlyButton").show();
             }
             else {
                 $("#WeighTrailerOnlyButton").hide();
             }

             popWeightDialogBoxWeights(weightValues);
             // PageMethods.getNetWeightAndSpecificGravity(MSID, onSuccess_getNetWeightAndSpecificGravity, onFail_getNetWeightAndSpecificGravity, weightValues[5]);
         }

         function onFail_getCurrentWeights(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getCurrentWeights");
         }

         function onSuccess_getNetWeightAndSpecificGravity(specGrav, netWeight, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var loadType = $("#weightDialogBox").data("data-loadType");

             if (netWeight > 0 && specGrav > 0) {
                 $("#lblNetWeight").html(netWeight);
                 $("#lblSpecificGravity").show(); 
                 $("#btnCalcNet").show();
                 $("#lblSpecificGravityVal").show();
                 $("#lblSpecificGravityVal").html(specGrav.toFixed(4));
                 $("#SampleWeights").show();
                 $("#lblNoSamples").hide();

                 var isNOS = $("#weightDialogBox").data("data-NOS");
                 if (isNOS == true) {
                     onClick_calcVol();
                     $("#btnVolCal").hide();
                 }
             }
             else if (specGrav > 0 && netWeight == 0) {
                 $("#lblSpecificGravity").show();
                 $("#lblSpecificGravityVal").show();
                 $("#lblSpecificGravityVal").html(specGrav.toFixed(4));
                 $("#SampleWeights").show();
                 $("#btnVolCal").hide();
             }
             else if (specGrav == 0 && netWeight > 0) {
                 $("#lblNetWeight").html(netWeight);
                 $("#btnCalcNet").show();
                 $("#lblSpecificGravity").hide();
                 $("#lblSpecificGravityVal").hide();
                 $("#SampleWeights").hide();
                 $("#btnVolCal").hide();
             }
             if (netWeight == 0 || specGrav == 0) {
                 //$("#SampleWeights").hide();
                 //$("#btnVolCal").hide();
                 //$("#lblSpecificGravity").hide();
                 //$("#lblSpecificGravityVal").hide();
                 $("#lblNoSamples").show();
                 if (netWeight == 0 && specGrav == 0) {
                     $("#lblNoSamples").html("Product weight cannot be calculated. </br>A sample with specific gravity has not been approved </br> and the net weight has not been calculated for this order.");
                     $("#lblSpecificGravityVal").hide();
                     $("#lblSpecificGravity").hide();
                     $("#btnCalcVol").hide();                     
                 }
                 else if (netWeight == 0) {
                     $("#lblNoSamples").html("Product weight cannot be calculated. </br>Net weight has not been calculated for this order. </br> ");
                     $("#lblSpecificGravityVal").show();
                     $("#lblSpecificGravity").show();
                     $("#btnCalcVol").hide();
                 }
                 else if (specGrav == 0) {
                     $("#lblNoSamples").html("Product weight cannot be calculated. </br>A sample with specific gravity has not been approved yet for this order.</br>");
                     $("#lblSpecificGravityVal").hide();
                     $("#lblSpecificGravity").hide();
                     $("#btnCalcVol").hide();
                 }
             }
         }

         function onSuccess_getNetWeightAndSpecificGravity_NOS(specGrav, netWeight, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             if (netWeight != 0 && specGrav != 0) {
                 $("#lblNetWeight").html(netWeight);
                 $("#lblSpecificGravityVal").html(specGrav.toFixed(4));
                 $("#SampleWeights").show();
                 $("#lblNoSamples").hide();
             }
             else {
                 $("#SampleWeights").hide();
                 $("#lblNoSamples").show();
                 if (netWeight == 0 && specGrav == 0) {
                     $("#lblNoSamples").html("Product weight cannot be calculated. </br>A sample with specific gravity has not been approved </br> and the net weight has not been calculated for this order.")
                 }
                 else if (netWeight == 0) {
                     $("#lblNoSamples").html("Product weight cannot be calculated. </br>Net weight has not been calculated for this order. </br> ")
                 }
                 else if (specGrav == 0) {
                     $("#lblNoSamples").html("Product weight cannot be calculated. </br>A sample with specific gravity has not been approved yet for this order.</br>")
                 }
             }
         }
         function onFail_getNetWeightAndSpecificGravity(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getNetWeightAndSpecificGravity");
         }

         function onSuccess_undoGrossWeight(value, ctx, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }

         function onFail_undoGrossWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoGrossWeight");
         }

         function onSuccess_undoCab1Weight(value, ctx, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);

         }

         function onFail_undoCab1Weight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoCab1Weight");
         }

         function onSuccess_undoCab2Weight(value, ctx, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }

         function onFail_undoCab2Weight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoCab2Weight");
         }
         function onSuccess_undoCab2wTrailerWeight(value, ctx, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }

         function onFail_undoCab2wTrailerWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoCab2wTrailerWeight");
         }

         function onSuccess_undoCab1wTrailerWeight(value, ctx, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }

         function onFail_undoCab1wTrailerWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoCab2wTrailerWeight");
         }
         function onSuccess_undoTrailerWeight(value, ctx, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }

         function onFail_undoTrailerWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoTrailerWeight");
         }

         function onSuccess_undoNetWeight(value, ctx, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }

         function onFail_undoNetWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoTrailerWeight");
         }

         function onSuccess_getCurrentLocationAndStatusB4Undo(currentLocStatus, MSID, methodName) {
             var loc = currentLocStatus[0];
             var stat = currentLocStatus[1];
             var canUndoCheckOut = currentLocStatus[2];

             if (canUndoCheckOut == false) {
                 alert("Check out can not be undone due to the trailer still being on site. (Location: " + loc + ", Status: " + stat + ")");
             }
             else {
                 $("#grid").data("data-MSID", MSID);
                 PageMethods.CheckCurrentStatus(MSID, onSuccess_CheckCurrentStatus_CheckInCheckOutAndUndos, onFail_CheckCurrentStatus, "uOut");

             }

         }
         function onFail_getCurrentLocationAndStatusB4Undo(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getCurrentLocationAndStatusB4Undo");
         }

         function onSuccess_AddFileDBEntry(value, ctx, methodName) {
             var msid = $('#MoreDetailsDialog').data("data-MSID");
             PageMethods.GetFileUploadsFromMSID(msid, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, msid);
         }

         function onFail_AddFileDBEntry(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_AddFileDBEntry");
         }
         function onSuccess_GetFileUploadsFromMSID(value, ctx, methodName) {
             var msid = ctx;
            <%--clear data from controls --%>
            $('#alinkBOL').text("");
            $('#alinkCOFA').text("");
            $('#dUpBOL').show();
            $('#dDelBOL').hide();
            $('#dUpCOFA').show();
            $('#dDelCOFA').hide();

            if (value.length > 0) {
                var gridData = [];

                var rowCount = 0;
                for (var i = 0; i < value.length; i++) {
                    if (1 === value[i][2]) { <%-- filetype 1 == BOL--%>
                        $('#alinkBOL').text(value[i][6]);
                        $("#alinkBOL").attr("href", value[i][4] + "/" + value[i][5]);
                        $('#dBOLcontainer').data("data-fileID", value[i][0]);
                        $('#dUpBOL').hide();
                        $('#dDelBOL').show();
                    }
                    else if (2 === value[i][2]) { <%-- filetype 2 == COFA --%>
                        $('#alinkCOFA').text(value[i][6]);
                        $("#alinkCOFA").attr("href", value[i][4] + "/" + value[i][5]);
                        $('#dCOFAcontainer').data("data-fileID", value[i][0]);
                        $('#dUpCOFA').hide();
                        $('#dDelCOFA').show();
                    }
                    else { <%-- OTHER --%>
                        <%-- add to list grid --%>
                        gridData[rowCount] = { "FID": value[i][0], "MSID": value[i][1], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5], "FNAMEOLD": value[i][6], "FUPDEL": "" };
                        rowCount += 1;
                    }
                }

                $("#gridFiles").igGrid("option", "dataSource", gridData);
                $("#gridFiles").igGrid("dataBind");
            }
            else { <%-- no data --%>
                var gridData = [];
                $("#gridFiles").igGrid("option", "dataSource", gridData);
                $("#gridFiles").igGrid("dataBind");
            }

        }

        function onFail_GetFileUploadsFromMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_GetFileUploadsFromMSID");
        }

        //function onSuccess_GetCOFAFileUploadsFromMSID(value, ctx, methodName) {
        //    var gridData = [];
        //    for (i = 0; i < value.length; i++) {
        //        value[i] = {
        //            "FID": value[i][0], "MSID": value[i][1], "FILETYPEID": value[i][2], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5],
        //            "FNAMEOLD": value[i][6], "CMSPRODUCTID": value[i][7], "CMSPRODUCTNAME": value[i][8]
        //        };
        //    }
        //    $("#gridCOFAFiles").igGrid("option", "dataSource", gridData);
        //    $("#gridCOFAFiles").igGrid("dataBind");
        //    $("#detailsDialog").data("ID", ctx).igDialog("open");

        //}

        //function onFail_GetCOFAFileUploadsFromMSID(value, ctx, methodName) {
        //    sendtoErrorPage("Error in guardStation.aspx, onFail_GetCOFAFileUploadsFromMSID");
        //}

        function onSuccess_UpdateFileUploadData(value, ctx, methodName) {
            <%--Success do nothing --%>
            $("#gridFiles").igGrid("commit");
        }

        function onFail_UpdateFileUploadData(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_UpdateFileUploadData");
        }


        function onSuccess_ProcessFileAndData(value, ctx, methodName) {
            if (ctx) {
                if ("BOL" === ctx[1]) {
                      <%--Add entry into DB --%>
                    PageMethods.AddFileDBEntry(ctx[2], "BOL", ctx[0], value[1], value[0], "BOL", onSuccess_AddFileDBEntry, onFail_AddFileDBEntry, ctx)

                }
                else if ("COFA" === ctx[1]) {
                      <%--Add entry into DB --%>
                    PageMethods.AddFileDBEntry(ctx[2], "COFA", ctx[0], value[1], value[0], "COFA", onSuccess_AddFileDBEntry, onFail_AddFileDBEntry, ctx)

                }
                else if ("OTHER" === ctx[1]) {
                    <%--Add OTHER filetype entry into db only happens on add row finished because need to get Detail column--%>
                    <%--add attributes related to grid for use when adding new row --%>
                    $("#gridFiles").data("data-FPath", value[0]);
                    $("#gridFiles").data("data-FNameNew", value[1]);
                    $("#gridFiles").data("data-FNameOld", ctx[0]);

                    <%--change text of add new row's filename column to uploaded file's original name --%>
                    //$("#detailsDialog tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(ctx[0]);
                }
        }
    }

    function onFail_ProcessFileAndData(value, ctx, methodName) {
        sendtoErrorPage("Error in guardStation.aspx, onFail_ProcessFileAndData");
    }

    function onSuccess_DeleteFileDBEntry(value, ctx, methodName) {

        var msid = $('#MoreDetailsDialog').data("data-MSID");
        PageMethods.GetFileUploadsFromMSID(msid, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, msid);
    }

    function onFail_DeleteFileDBEntry(value, ctx, methodName) {
        sendtoErrorPage("Error in guardStation.aspx, onFail_DeleteFileDBEntry");
    }

    function onSuccess_verifyAndMove(returnString, ctx, methodName) {
        if (returnString == 'success') {
            
             $("#msgSendTruck").css("display", "block");
             $("#msgSendTruck").fadeOut(3000);
            PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
        }
        else {
            alert(returnString);
        }

    }

    function onFail_verifyAndMove(value, ctx, methodName) {
        sendtoErrorPage("Error in guardStation.aspx onFail_verifyAndMove");
    }

         <%-------------------------------------------------------
        Button Click Handlers
        -------------------------------------------------------%>
         function openProductDetailDialog(MSID) {
             var PO = $("#grid").igGrid("getCellValue", MSID, "PO");
             var trailer = $("#grid").igGrid("getCellValue", MSID, "TRAILER");
             var POTrailer = comboPOAndTrailer(PO, trailer);
             PageMethods.GetPODetailsFromMSID(MSID, onSuccess_GetPODetailsFromMSID, onFail_GetPODetailsFromMSID, MSID);
             if (POTrailer) {
                 $("#dvProductDetailsPONUM").text(POTrailer);
             }
         }

         function clearGridFilters(evt, ui) {
             $("#grid").igGridFiltering("filter", []);
         }



         function onClick_OpenWeighInDialogDiv() {
             var NOS = $("#weightDialogBox").data("data-NOS");
             $("#RightWeightSection").css("border", "1px solid lightgrey");
             $("#RightWeightSection").css("padding-left", "10px");
             
             $("#weightOptionsIn").show();
             $("#weightOptionsOut").hide();
             $("#weightOptionsTrailer").hide();
             $("#weightDialogBox").data("data-ButtonPressed", "in");
             var isNOS = $("#weightDialogBox").data("data-NOS");
             if (isNOS) {
                 $("#lblWeightQuestion").html("");
             }
             else {
                 $("#lblWeightQuestion").html("What are you weighing in?");
             }
             $("#lblWeightQuestion").show();
         }

         function onClick_OpenTrailerOnlyDialogDiv() {
             $("#RightWeightSection").css("border", "1px solid lightgrey");
             $("#RightWeightSection").css("padding-left", "10px");
             $("#weightOptionsTrailer").show();
             $("#weightOptionsIn").hide();
             $("#weightOptionsOut").hide();
             $("#weightDialogBox").data("data-ButtonPressed", "trailer");
             var isNOS = $("#weightDialogBox").data("data-NOS");
             if (isNOS) {
                 $("#lblWeightQuestion").html("");
             }
             else {
                 $("#lblWeightQuestion").html("Weigh Options:");
             }
             $("#lblWeightQuestion").show();
         }
         function onClick_OpenWeighOutDialogDiv() {
             $("#RightWeightSection").css("border", "1px solid lightgrey");
             $("#RightWeightSection").css("padding-left", "10px");
             $("#weightOptionsOut").show();
             $("#weightOptionsIn").hide();
             $("#weightOptionsTrailer").hide();
             $("#weightDialogBox").data("data-ButtonPressed", "out");
             var isNOS = $("#weightDialogBox").data("data-NOS");
             if (isNOS) {
                 $("#lblWeightQuestion").html("");
             }
             else {
                 $("#lblWeightQuestion").html("What are you weighing out?");
             }
             $("#lblWeightQuestion").show();
         }

         function restoreToCorrectWeightDisplayAfterRepop(buttonPressed) {
             if (buttonPressed == 'in') {
                 onClick_OpenWeighInDialogDiv();
             }
             else if (buttonPressed == 'trailer') {
                 onClick_OpenTrailerOnlyDialogDiv();
             }
             else if (buttonPressed == 'out') {
                 onClick_OpenWeighOutDialogDiv();
             }
         }
         
         function onclick_ShowTodaysTrucks() {
             clearGridFilters();
             var todayDate = new Date();
             $("#grid").igGridFiltering("filter",
                 [{ fieldName: "ETA", expr: todayDate.toDateString(), cond: "on" }],
                 true);
         }
         function onclick_ShowOpenInCMSButOutOfPlant(evt, ui) {
             clearGridFilters();
             $("#grid").igGridFiltering("filter",
                 [{ fieldName: "LOCATION", expr: "NOS", cond: "equals" },
                  { fieldName: "BoolIsOpenInCMS", expr: true, cond: "equals" },
                  { fieldName: "STATUS", expr: 10, cond: "equals" }
                 ],
                 true);
         }
         function onclick_ShowAllScheduledTrucks(evt, ui) {
             clearGridFilters()
         }
         function onclick_btnUpdateLocation() {
             var MSID = $("#undoCheckOutLocationDialogBox").data("data-MSID");
             var newLocation = $("#cboxLocations").igCombo("value");
             var dSpot = $("#cboxDockSpots").igCombo("value");
             if ((newLocation == 'DOCKVAN' || newLocation == 'DOCKBULK') && checkNullOrUndefined(dSpot) == true) {
                 alert("You must specify which dock spot you want to move to. ");
             }
             else {
                 var newLocation = $("#cboxLocations").igCombo("value");
                 var dSpot = $("#cboxDockSpots").igCombo("value");
                 if (newLocation == 'DOCKVAN' || newLocation == 'DOCKBULK') {
                     PageMethods.verifySpotIsCurrentlyAvailable(MSID, dSpot, onSuccess_verifySpotIsCurrentlyAvailable, onFail_verifySpotIsCurrentlyAvailable, MSID);
                 }
                 else {
                     PageMethods.updateLocationAndUndoCheckOut(MSID, newLocation, 0, onSuccess_updateLocationAndUndoCheckOut, onFail_updateLocationAndUndoCheckOut, MSID);
                 }
             }
         }
         function onClick_calcVol() {
             var netProduct = $("#lblNetWeight").html();
             var isNetANumber = $.isNumeric(netProduct);
             var specificGravity = $("#lblSpecificGravityVal").html();
             var isGravANumber = $.isNumeric(specificGravity);
                 if (isNetANumber == false && isGravANumber == true) {
                     alert("Missing Net weight for volume calculation");
                 }
                 else if (isNetANumber == true && isGravANumber == false) {
                     alert("Missing Specific Gravity weight for volume calculation");
                 }
                 else if (isNetANumber == true && isGravANumber == true) {
                     var vol = netProduct / (specificGravity * 8.32823); <%--8.32823 constant--%>
                     $("#lblVolVal").html(vol.toFixed(2));
                 }
         }
         function onClick_calcWeight(weightType) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var currentGross = $("#lblGrossWeight").html(); <%--gross--%>
             var currentCab1 = $("#lblCab1Weight").html();<%--cab1--%>
             var currentCab2 = $("#lblCab2Weight").html();<%--cab2--%>
             var currentCab2WTrailer = $("#lblCab2wTrailerWeight").html();<%--cab2WTrailer--%>
             var currentTrailer = $("#lblTrailerWeight").html();<%--trailer--%>
             var currentNet = $("#lblNetWeight").html();<%--net--%>

             switch (weightType) {
                 case 2:<%--cab1--%>
                     //if (currentCab2WTrailer > 0 && currentTrailer > 0) {
                     PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     //}
                     //else {
                     //    alert("There is not enough weight data to calculated the weight of Cab In at this time. Please refresh the page and try again.")
                     //}
                     break;
                 case 3:<%--cab2--%>
                     //if (isDropTrailer == true) {
                     // if (currentCab2WTrailer > 0 && currentTrailer > 0) {
                     PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     //}
                     //else {
                     //    alert("There is not enough weight data to calculated the weight of Cab Out at this time. Please refresh the page and try again.")
                     //}
                     // }
                     //else {
                     //    alert("This order is not a drop trailer and this weight can not be calculated");
                     //}
                     break;
                 case 4:<%--cab2WTrailer--%>
                     //if ((currentCab2 > 0 && currentTrailer > 0) ||
                     //    (currentNet > 0 && currentTrailer > 0)) {
                     PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     //}
                     //else {
                     //    alert("There is not enough weight data to calculated the weight of Cab Out With Trailer at this time. Please refresh the page and try again.")
                     //}

                     break;
                 case 5:<%--trailer--%>
                     //if ((currentCab2WTrailer > 0 && currentCab2 > 0) ||
                     //    (currentCab1WTrailer > 0 && currentCab1 > 0)){
                     PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     //}
                     //else {
                     //  alert("There is not enough weight data to calculated the weight of Trailer at this time. Please refresh the page and try again.")
                     //}

                     break;
                 case 6:<%--net--%>
                     //if ((currentGross > 0 && currentCab2WTrailer > 0) ||
                     //    (currentGross > 0 && currentCab1WTrailer > 0) ||
                     //    (currentGross > 0 && currentCab2 > 0 && currentCab2WTrailer) ||
                     //    (currentGross > 0 && currentCab1 > 0 && currentCab1WTrailer)) {
                     PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     //}
                     break;
                 case 7:<%--cab1WTrailer--%>
                     //if ((currentCab1 > 0 && currentTrailer > 0) ||
                     //    (currentNet > 0 && currentTrailer > 0)) {
                         PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     //}
                     //else {
                     //    alert("There is not enough weight data to calculated the weight of Cab In With Trailer at this time. Please refresh the page and try again.")
                     //}
                     break;

             }
         }

         function popGrossShowAndHideWeight(GrossVal, GrossObtainMethod) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var loadType = $("#weightDialogBox").data("data-loadType");
             var hasDropped = $("#weightDialogBox").data("data-hasTrailerDropped");
             var grossLbl = null;
             var grossWeightLbl = null;


             if (GrossVal > 0.0) {//Gross
                 if (loadType == 'Load In') {
                     grossLbl = "#lblInGross";
                     grossWeightLbl = "#lblInGrossWeight";

                     $("#lblInGross").show();
                     $("#btnInGrossWeight").hide();
                     $("#lblInGrossWeight").show();
                     $("#undoInGrossWeight").show();
                     $("#btnInManualGrossWeight").hide();


                     $("#lblOutGross").hide();
                     $("#btnOutGrossWeight").hide();
                     $("#lblOutGrossWeight").hide();
                     $("#undoOutGrossWeight").hide();
                     $("#btnOutManualGrossWeight").hide();
                 }
                 else {
                     grossLbl = "#lblOutGross";
                     grossWeightLbl = "#lblOutGrossWeight";

                     $("#lblOutGross").show();
                     $("#btnOutGrossWeight").hide();
                     $("#lblOutGrossWeight").show();
                     $("#undoOutGrossWeight").show();
                     $("#btnOutManualGrossWeight").hide();

                     $("#lblInGross").hide();
                     $("#btnInGrossWeight").hide();
                     $("#lblInGrossWeight").hide();
                     $("#undoInGrossWeight").hide();
                     $("#btnInManualGrossWeight").hide();

                 }
                 
                <%-- if (loadType == 'Load Out' && isDropTrailer == 'Yes') {
                     this was done at Matt's request 
                     switch (GrossObtainMethod) {
                         case 1:
                             $(grossLbl).html("Cab Out w/ Trailer & Product(s) - From Scale: ");
                             break;
                         case 2:
                             $(grossLbl).html("Cab Out w/ Trailer & Product(s) - Manually Entered: ");
                             break;
                         case 3:
                             $(grossLbl).html("Cab Out w/ Trailer & Product(s) - Calculated: ");
                             break;
                     }
                 }
                 else {--%>
                     switch (GrossObtainMethod) {
                         case 1:
                             $(grossLbl).html("Cab 1 w/ Trailer & Product(s) - From Scale: ");
                             break;
                         case 2:
                             $(grossLbl).html("Cab 1 w/ Trailer & Product(s) - Manually Entered: ");
                             break;
                         case 3:
                             $(grossLbl).html("Cab 1 w/ Trailer & Product(s) - Calculated: ");
                             break;
                     }
                 //}
                 $(grossWeightLbl).html(GrossVal);
             }
             else {//gross is not set
                 $("#undoInGrossWeight").hide();
                 $("#undoOutGrossWeight").hide();

                 if (loadType == 'Load In') {
                     grossLbl = "#lblInGross";
                     grossWeightLbl = "#lblInGrossWeight";

                     $("#lblOutGross").hide();
                     $("#btnOutGrossWeight").hide();
                     $("#lblOutGrossWeight").hide();
                     $("#btnOutManualGrossWeight").hide();

                     $("#lblInGross").show();
                     $("#btnInGrossWeight").show();
                     $("#lblInGrossWeight").hide();
                     $("#btnInManualGrossWeight").show();
                 }
                 else {
                     grossLbl = "#lblOutGross";
                     grossWeightLbl = "#lblOutGrossWeight";

                     $("#lblInGross").hide();
                     $("#btnInGrossWeight").hide();
                     $("#lblInGrossWeight").hide();
                     $("#btnInManualGrossWeight").hide();


                     $("#lblOutGross").show();
                     $("#btnOutGrossWeight").show();
                     $("#lblOutGrossWeight").hide();
                     $("#btnOutManualGrossWeight").show();
                 }
                 <%--if (loadType == 'Load Out' && isDropTrailer == 'Yes') {
                     this was done at Matt's request 
                     $(grossLbl).html("Cab Out w/ Trailer & Product(s): ");
                 }
                 else {--%>
                     $(grossLbl).html("Cab 1 w/ Trailer & Product(s): ");
                // }
                 $(grossWeightLbl).html("");
             }
         }


         function popCab1ShowAndHideWeight(Cab1Val, Cab1ValObtainMethod) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var loadType = $("#weightDialogBox").data("data-loadType");
             var hasDropped = $("#weightDialogBox").data("data-hasTrailerDropped");
             var shouldCab1CalcButtonBeDisabled = shouldCalcButtonBeDisabled("cab1Solo");
             var cab1SoloLbl = null;
             var cab1SoloWeightLbl = null;


             if (Cab1Val > 0.0) {<%--cab 1--%>
                 if (loadType == 'Load Out' && isDropTrailer == 'No') {                     
                     $("#lblInCab1TextDialogBox").show();
                     $("#btnInCab1Weight").hide();
                     $("#lblInCab1Weight").show();
                     $("#undoInCab1Weight").show();
                     $("#btnInManualCab1Weight").hide();
                     $("#btnInCalCab1").hide();

                     $("#lblOutCab1TextDialogBox").hide();
                     $("#btnOutCab1Weight").hide();
                     $("#lblOutCab1Weight").hide();
                     $("#undoOutCab1Weight").hide();
                     $("#btnOutManualCab1Weight").hide();
                     $("#btnOutCalCab1").hide()

                     cab1SoloLbl = "#lblInCab1TextDialogBox";
                     cab1SoloWeightLbl = "#lblInCab1Weight";
                     
                 }
                 else {
                     if (isDropTrailer == 'Yes') {
                         cab1SoloLbl = "#lblOutCab1TextDialogBox";
                         cab1SoloWeightLbl = "#lblOutCab1Weight";
                         $("#lblOutCab1TextDialogBox").show();
                         $("#btnOutCab1Weight").hide();
                         $("#lblOutCab1Weight").show();
                         $("#undoOutCab1Weight").show();
                         $("#btnOutManualCab1Weight").hide();
                         $("#btnOutCalCab1").hide();

                         $("#lblInCab1TextDialogBox").hide();
                         $("#btnInCab1Weight").hide();
                         $("#lblInCab1Weight").hide();
                         $("#undoInCab1Weight").hide();
                         $("#btnInManualCab1Weight").hide();
                         $("#btnInCalCab1").hide();

                     }
                     else {
                         cab1SoloLbl = "#lblInCab1TextDialogBox";
                         cab1SoloWeightLbl = "#lblInCab1Weight";
                         $("#lblOutCab1TextDialogBox").hide();
                         $("#btnOutCab1Weight").hide();
                         $("#lblOutCab1Weight").hide();
                         $("#undoOutCab1Weight").hide();
                         $("#btnOutManualCab1Weight").hide();
                         $("#btnOutCalCab1").hide();

                         $("#lblInCab1TextDialogBox").show();
                         $("#btnInCab1Weight").hide();
                         $("#lblInCab1Weight").show();
                         $("#undoInCab1Weight").show();
                         $("#btnInManualCab1Weight").hide();
                         $("#btnInCalCab1").hide();
                     }
                 }

                 if (cab1SoloLbl != null) {
                     if (loadType == 'Load Out' && isDropTrailer == 'Yes') {
                         <%--this was done at Matt's request --%>
                         switch (Cab1ValObtainMethod) {
                             case 1:
                                 $(cab1SoloLbl).html("Cab 2 Only - From Scale: ");
                                 break;
                             case 2:
                                 $(cab1SoloLbl).html("Cab 2 Only - Manually Entered: ");
                                 break;
                             case 3:
                                 $(cab1SoloLbl).html("Cab 2 Only - Calculated: ");
                                 break;
                         }

                     }
                     else{
                     switch (Cab1ValObtainMethod) {
                         case 1:
                             $(cab1SoloLbl).html("Cab 1 Only - From Scale: ");
                             break;
                         case 2:
                             $(cab1SoloLbl).html("Cab 1 Only - Manually Entered: ");
                             break;
                         case 3:
                             $(cab1SoloLbl).html("Cab 1 Only - Calculated: ");
                             break;
                     }
                         }
                     $(cab1SoloWeightLbl).html(Cab1Val);
                 }

             }
             else {//cab1Solo is not set
                     $("#undoOutCab1Weight").hide();
                     $("#undoInCab1Weight").hide();
                     if (loadType == 'Load Out' && isDropTrailer == 'No') {    
                         cab1SoloLbl = "#lblInCab1TextDialogBox";
                         cab1SoloWeightLbl = "#lblInCab1Weight";
                         $("#lblInCab1TextDialogBox").show();
                         $("#btnInCab1Weight").show();
                         $("#lblInCab1Weight").hide();
                         $("#btnInManualCab1Weight").show();
                         $("#btnInCalCab1").show();

                         $("#lblOutCab1TextDialogBox").hide();
                         $("#btnOutCab1Weight").hide();
                         $("#lblOutCab1Weight").hide();
                         $("#undoOutCab1Weight").hide();
                         $("#btnOutManualCab1Weight").hide();
                         $("#btnOutCalCab1").hide()


                     }
                     else {
                         if (isDropTrailer == 'Yes') {
                             cab1SoloLbl = "#lblOutCab1TextDialogBox";
                             cab1SoloWeightLbl = "#lblOutCab2Weight";

                             $("#lblOutCab1TextDialogBox").show();
                             $("#btnOutCab1Weight").show();
                             $("#lblOutCab1Weight").hide();
                             $("#btnOutManualCab1Weight").show();
                             $("#btnOutCalCab1").show();

                             $("#lblInCab1TextDialogBox").hide();
                             $("#btnInCab1Weight").hide();
                             $("#lblInCab1Weight").hide();
                             $("#btnInManualCab1Weight").hide();
                             $("#btnInCalCab1").hide();

                         }
                         else {
                             $("#lblOutCab1TextDialogBox").hide();
                             $("#btnOutCab1Weight").hide();
                             $("#lblOutCab1Weight").hide();
                             $("#btnOutManualCab1Weight").hide();
                             $("#btnOutCalCab1").hide();

                             $("#lblInCab1TextDialogBox").show();
                             $("#btnInCab1Weight").show();
                             $("#lblInCab1Weight").hide();
                             $("#btnInManualCab1Weight").show();
                             $("#btnInCalCab1").show();
                         }
                         <%--if (loadType == 'Load Out' && isDropTrailer == 'Yes') {
                         this was done at Matt's request 
                             $(cab1SoloLbl).html("Cab Out Only: ");
                         }
                         else {--%>
                             $(cab1SoloLbl).html("Cab 1 Only: ");
                         //}
                         $(cab1SoloWeightLbl).html("");
                     } <%-- end of if/else section of(loadtype=='load out')--%>

                 if (shouldCab1CalcButtonBeDisabled) {
                     $("#btnInCalCab1").prop("disabled", true);
                     $("#btnOutCalCab1").prop("disabled", true);
                 }
                 else {
                     $("#btnInCalCab1").prop("disabled", false);
                     $("#btnOutCalCab1").prop("disabled", false);
                 }


             }
         }



         function popCab2ShowAndHideWeight(Cab2Val, Cab2ValObtainMethod) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var loadType = $("#weightDialogBox").data("data-loadType");
             var hasDropped = $("#weightDialogBox").data("data-hasTrailerDropped");
             var shouldCab2CalcButtonBeDisabled = shouldCalcButtonBeDisabled("cab2Solo");


             if (Cab2Val > 0.0) {<%--cab 2--%>
                 if (loadType == 'Load In') {
                     if (isDropTrailer == 'Yes' && hasDropped == true) {
                         $("#lblInCab2TextDialogBox").show();
                         $("#btnInCab2Weight").hide();
                         $("#lblInCab2Weight").show();
                         $("#undoInCab2Weight").show();
                         $("#btnInManualCab2Weight").hide();
                         $("#btnInCalCab2").hide();
                     }
                     else {
                         $("#lblInCab2TextDialogBox").hide();
                         $("#btnInCab2Weight").hide();
                         $("#lblInCab2Weight").hide();
                         $("#undoInCab2Weight").hide();
                         $("#btnInManualCab2Weight").hide();
                         $("#btnInCalCab2").hide();
                     }
                     switch (Cab2ValObtainMethod) {
                         case 1:
                             $("#lblInCab2TextDialogBox").html("Cab 2 Only - From Scale: ");
                             break;
                         case 2:
                             $("#lblInCab2TextDialogBox").html("Cab 2 Only - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblInCab2TextDialogBox").html("Cab 2 Only - Calculated: ");
                             break;
                     }
                     $("#lblInCab2Weight").html(Cab2Val);
                 }
             }
             else {//cab2Solo is not set
                 $("#undoInCab2Weight").hide();
                 $("#lblInCab2TextDialogBox").html("Cab 2 Only: ");
                 $("#lblInCab2Weight").html("");

                 if (isDropTrailer == 'Yes' && hasDropped == true && loadType == "Load In") {
                     $("#lblInCab2TextDialogBox").show();
                     $("#btnInCab2Weight").show();
                     $("#lblInCab2Weight").hide();
                     $("#btnInManualCab2Weight").show();
                     $("#btnInCalCab2").show();
                 }
                 else {
                     $("#lblInCab2TextDialogBox").hide();
                     $("#btnInCab2Weight").hide();
                     $("#lblInCab2Weight").hide();
                     $("#btnInManualCab2Weight").hide();
                     $("#btnInCalCab2").hide();
                 }

                 if (shouldCab2CalcButtonBeDisabled) {
                     $("#btnInCalCab2").prop("disabled", true);
                 }
                 else {
                     $("#btnInCalCab2").prop("disabled", false);
                 }

             }
         }



         function popCab2withTrailerShowAndHideWeight(Cab2withTrailerVal, Cab2withTrailerValObtainMethod) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var loadType = $("#weightDialogBox").data("data-loadType");
             var hasDropped = $("#weightDialogBox").data("data-hasTrailerDropped");
             var shouldCab2withTrailerCalcButtonBeDisabled = shouldCalcButtonBeDisabled("cab2WithTrailer");

             if (Cab2withTrailerVal > 0.0) {//Cab 2 w/ MT trailer
                 if (isDropTrailer == 'Yes' && hasDropped == true) {
                     $("#lblOutCab2wTrailerTextDialogBox").show();
                     $("#btnOutCab2wTrailerWeight").hide();
                     $("#lblOutCab2wTrailerWeight").show();
                     $("#undoOutCab2wTrailerWeight").show();
                     $("#btnOutManualCab2wTrailerWeight").hide();
                     $("#btnOutCalCab2wTrailer").hide();
                 }
                 else {
                     $("#lblOutCab2wTrailerTextDialogBox").hide();
                     $("#btnOutCab2wTrailerWeight").hide();
                     $("#lblOutCab2wTrailerWeight").hide();
                     $("#undoOutCab2wTrailerWeight").hide();
                     $("#btnOutManualCab2wTrailerWeight").hide();
                     $("#btnOutCalCab2wTrailer").hide();
                 }
                 switch (Cab2withTrailerValObtainMethod) {
                     case 1:
                         $("#lblOutCab2wTrailerTextDialogBox").html("Cab 2 w/ Trailer - From Scale: ");
                         break;
                     case 2:
                         $("#lblOutCab2wTrailerTextDialogBox").html("Cab 2 w/ Trailer - Manually Entered: ");
                         break;
                     case 3:
                         $("#lblOutCab2wTrailerTextDialogBox").html("Cab 2 w/ Trailer - Calculated: ");
                         break;
                 }
                 $("#lblOutCab2wTrailerWeight").html(Cab2withTrailerVal);
             }
             else {//cab2 with Trailer is not set
                 $("#lblOutCab2wTrailerTextDialogBox").html("Cab 2 w/ Trailer: ");
                 $("#lblOutCab2wTrailerWeight").html("");
                 if (isDropTrailer == 'Yes' && hasDropped == true && loadType == "Load In") {
                     $("#lblOutCab2wTrailerTextDialogBox").show();
                     $("#btnOutCab2wTrailerWeight").show();
                     $("#lblOutCab2wTrailerWeight").hide();
                     $("#undoOutCab2wTrailerWeight").hide();
                     $("#btnOutManualCab2wTrailerWeight").show();
                     $("#btnOutCalCab2wTrailer").show();
                 }
                 else {
                     $("#lblOutCab2wTrailerTextDialogBox").hide();
                     $("#btnOutCab2wTrailerWeight").hide();
                     $("#lblOutCab2wTrailerWeight").hide();
                     $("#undoOutCab2wTrailerWeight").hide();
                     $("#btnOutManualCab2wTrailerWeight").hide();
                     $("#btnOutCalCab2wTrailer").hide();
                 }

                 if (shouldCab2withTrailerCalcButtonBeDisabled) {
                     $("#btnOutCalCab2wTrailer").prop("disabled", true);
                 }
                 else {
                     $("#btnOutCalCab2wTrailer").prop("disabled", false);
                 }
             }

         }

         function popCab1withTrailerShowAndHideWeight(Cab1withTrailerVal, Cab1withTrailerValObtainMethod) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var loadType = $("#weightDialogBox").data("data-loadType");
             var hasDropped = $("#weightDialogBox").data("data-hasTrailerDropped");
             var shouldCab1withTrailerCalcButtonBeDisabled = shouldCalcButtonBeDisabled("cab1WithTrailer");
             var cab1WithTrailerLbl = null;
             var cab1WithTrailerWeightLbl = null;

             if (loadType == "Load In") {
                 cab1WithTrailerLbl = "#lblOutCab1wTrailerTextDialogBox"
                 cab1WithTrailerWeightLbl = "#lblOutCab1wTrailerWeight"
             }
             else {
                 cab1WithTrailerLbl = "#lblInCab1wTrailerTextDialogBox"
                 cab1WithTrailerWeightLbl = "#lblInCab1wTrailerWeight"
             }


             if (Cab1withTrailerVal > 0.0) {//Cab 1 w/ MT trailer
                 if (loadType == "Load In") {
                     $("#lblOutCab1wTrailerTextDialogBox").show();
                     $("#btnOutCab1wTrailerWeight").hide();
                     $("#lblOutCab1wTrailerWeight").show();
                     $("#undoOutCab1wTrailerWeight").show();
                     $("#btnOutManualCab1wTrailerWeight").hide();
                     $("#btnOutCalCab1wTrailer").hide();


                     $("#lblInCab1wTrailerTextDialogBox").hide();
                     $("#btnInCab1wTrailerWeight").hide();
                     $("#lblInCab1wTrailerWeight").hide();
                     $("#undoInCab1wTrailerWeight").hide();
                     $("#btnInManualCab1wTrailerWeight").hide();
                     $("#btnInCalCab1wTrailer").hide();
                 }
                 else {
                     $("#lblInCab1wTrailerTextDialogBox").show();
                     $("#btnInCab1wTrailerWeight").hide();
                     $("#lblInCab1wTrailerWeight").show();
                     $("#undoInCab1wTrailerWeight").show();
                     $("#btnInManualCab1wTrailerWeight").hide();
                     $("#btnInCalCab1wTrailer").hide();

                     $("#lblOutCab1wTrailerTextDialogBox").hide();
                     $("#btnOutCab1wTrailerWeight").hide();
                     $("#lblOutCab1wTrailerWeight").hide();
                     $("#undoOutCab1wTrailerWeight").hide();
                     $("#btnOutManualCab1wTrailerWeight").hide();
                     $("#btnOutCalCab1wTrailer").hide();
                 }
                 switch (Cab1withTrailerValObtainMethod) {
                     case 1:
                         $(cab1WithTrailerLbl).html("Cab 1 w/ Trailer - From Scale: ");
                         break;
                     case 2:
                         $(cab1WithTrailerLbl).html("Cab 1 w/ Trailer - Manually Entered: ");
                         break;
                     case 3:
                         $(cab1WithTrailerLbl).html("Cab 1 w/ Trailer - Calculated: ");
                         break;
                 }
                 $(cab1WithTrailerWeightLbl).html(Cab1withTrailerVal);
             }
             else {//cab 1 with Trailer is not set
                 $("#undoOutCab1wTrailerWeight").hide();
                 $("#undoInCab1wTrailerWeight").hide();
                 $("#lblInCab1wTrailerTextDialogBox").html("Cab 1 w/ Trailer: ");
                 $("#lblOutCab1wTrailerTextDialogBox").html("Cab 1 w/ Trailer: ");
                 $("#lblInCab1wTrailerWeight").html("");
                 $("#lblOutCab1wTrailerWeight").html("");


                 if (loadType == "Load In") {
                     $("#lblInCab1wTrailerTextDialogBox").hide();
                     $("#btnInCab1wTrailerWeight").hide();
                     $("#lblInCab1wTrailerWeight").hide();
                     $("#undoInCab1wTrailerWeight").hide();
                     $("#btnInManualCab1wTrailerWeight").hide();
                     $("#btnInCalCab1wTrailer").hide();


                     $("#lblOutCab1wTrailerTextDialogBox").show();
                     $("#btnOutCab1wTrailerWeight").show();
                     $("#lblOutCab1wTrailerWeight").hide();
                     $("#undoOutCab1wTrailerWeight").hide();
                     $("#btnOutManualCab1wTrailerWeight").show();
                     $("#btnOutCalCab1wTrailer").show();

                    
                 }
                 else {
                     $("#lblInCab1wTrailerTextDialogBox").show();
                     $("#btnInCab1wTrailerWeight").show();
                     $("#lblInCab1wTrailerWeight").hide();
                     $("#undoInCab1wTrailerWeight").hide();
                     $("#btnInManualCab1wTrailerWeight").show();
                     $("#btnInCalCab1wTrailer").show();


                     $("#lblOutCab1wTrailerTextDialogBox").hide();
                     $("#btnOutCab1wTrailerWeight").hide();
                     $("#lblOutCab1wTrailerWeight").hide();
                     $("#undoOutCab1wTrailerWeight").hide();
                     $("#btnOutManualCab1wTrailerWeight").hide();
                     $("#btnOutCalCab1wTrailer").hide();

                 }

                 if (shouldCab1withTrailerCalcButtonBeDisabled) {
                     $("#btnOutCalCab1wTrailer").prop("disabled", true);
                     $("#btnInCalCab1wTrailer").prop("disabled", true);
                 }
                 else {
                     $("#btnOutCalCab1wTrailer").prop("disabled", false);
                     $("#btnInCalCab1wTrailer").prop("disabled", false);
                 }

             }
         }



         function popTrailerShowAndHideWeight(TrailerVal, TrailerValObtainMethod) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var loadType = $("#weightDialogBox").data("data-loadType");
             var hasDropped = $("#weightDialogBox").data("data-loadType");
             var shouldTrailerCalcButtonBeDisabled = shouldCalcButtonBeDisabled("trailer");

             if (TrailerVal > 0.0) {<%--Trailer--%>
                 $("#lblTrailerWeight").html(TrailerVal);
                 if (isDropTrailer.toLowerCase() == "yes" || loadType.toLowerCase() == "load out") {
                     $("#lblTrailerTextDialogBox").show();
                     $("#btnTrailerWeight").hide();
                     $("#lblTrailerWeight").show();
                     $("#undoTrailerWeight").show();
                     $("#btnManualTrailerWeight").hide();
                     $("#btnCalcTrailer").hide();
                     switch (TrailerValObtainMethod) {
                         case 1:
                             $("#lblTrailerTextDialogBox").html("Trailer Only - From Scale: ");
                             break;
                         case 2:
                             $("#lblTrailerTextDialogBox").html("Trailer Only - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblTrailerTextDialogBox").html("Trailer Only - Calculated: ");
                             break;
                     }
                 }
             }
             else {
                 $("#lblTrailerTextDialogBox").html("Trailer Only: ");
                 $("#lblTrailerWeight").html("");

                 $("#lblTrailerTextDialogBox").show();
                 $("#btnTrailerWeight").show();
                 $("#lblTrailerWeight").hide();
                 $("#undoTrailerWeight").hide();
                 $("#btnManualTrailerWeight").show();
                 $("#btnCalcTrailer").show();

                 if (shouldTrailerCalcButtonBeDisabled) {
                     $("#btnCalcTrailer").prop("disabled", true);
                 }
                 else {
                     $("#btnCalcTrailer").prop("disabled", false);
                 }

             }
         }


         function popNetShowAndHideWeight(NetVal) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var shouldNetCalcButtonBeDisabled = shouldCalcButtonBeDisabled("net");

             if (NetVal > 0.0) { <%--Net--%>
                 $("#btnCalcNet").html("Recalculate Net");
                 $("#lblNetWeight").html(NetVal);
                 $("#btnCalcVol").show();
             }
             else {
                 $("#btnCalcNet").html("Calculate Net");
                 $("#lblNetWeight").html("");
                 $("#btnCalcVol").hide();
                 if (shouldNetCalcButtonBeDisabled) {
                     $("#btnCalcNet").show();
                 }
                 else {
                     $("#btnCalcNet").hide();
                 }
             }

             if (areAllWeightsZero()) {
                 $("#btnCalcNet").hide();
             }
             PageMethods.getNetWeightAndSpecificGravity(MSID, onSuccess_getNetWeightAndSpecificGravity, onFail_getNetWeightAndSpecificGravity, NetVal);
         }


         function areAllWeightsZero()
         {
             var grossWeight = $("#weightDialogBox").data("data-grossWeight");
             var cab1SoloWeight = $("#weightDialogBox").data("data-cab1SoloWeight");
             var cab2SoloWeight = $("#weightDialogBox").data("data-cab2SoloWeight");
             var cab2WTrailerWeight = $("#weightDialogBox").data("data-cab2WithTrailerWeight");
             var trailerWeight = $("#weightDialogBox").data("data-trailerWeight");
             var netWeight = $("#weightDialogBox").data("data-netWeight");
             var cab1WTrailerWeight = $("#weightDialogBox").data("data-cab1WithTrailerWeight");

             if (grossWeight === 0 &&
                 cab1SoloWeight === 0 &&
                 cab2SoloWeight === 0 &&
                 cab2WTrailerWeight === 0 &&
                 trailerWeight === 0 &&
                 netWeight === 0 &&
                 cab1WTrailerWeight === 0) {
                 return true;
             }
             return false;
         }
         function shouldCalcButtonBeDisabled(weightBeingEvualted) {
             var grossWeight = $("#weightDialogBox").data("data-grossWeight");
             var cab1SoloWeight = $("#weightDialogBox").data("data-cab1SoloWeight");
             var cab2SoloWeight = $("#weightDialogBox").data("data-cab2SoloWeight");
             var cab2WTrailerWeight = $("#weightDialogBox").data("data-cab2WithTrailerWeight");
             var trailerWeight = $("#weightDialogBox").data("data-trailerWeight");
             var netWeight = $("#weightDialogBox").data("data-netWeight");
             var cab1WTrailerWeight = $("#weightDialogBox").data("data-cab1WithTrailerWeight");


             var MSID = $("#weightDialogBox").data("data-MSID");
             var isDropTrailer = $("#weightDialogBox").data("data-isDropTrailer");
             var hasTrailerDropped = $("#weightDialogBox").data("data-hasTrailerDropped");
             var currentGross = $("#lblGrossWeight").html(); <%--gross--%>
             var currentCab1 = $("#lblCab1Weight").html();<%--cab1--%>
             var currentCab2 = $("#lblCab2Weight").html();<%--cab2--%>
             var currentCab2WTrailer = $("#lblCab2wTrailerWeight").html();<%--cab2WTrailer--%>
             var currentTrailer = $("#lblTrailerWeight").html();<%--trailer--%>
             var currentNet = $("#lblNetWeight").html();<%--net--%>

             if (areAllWeightsZero) {
                 return true;
             }

             switch (weightBeingEvualted) {
                 case "cab1Solo":
                     if (cab1WTrailerWeight > 0 && trailerWeight > 0)
                         return true;
                     else
                         return false;
                 case "cab2Solo":
                     if (cab2WTrailerWeight > 0 && trailerWeight > 0)
                         return true;
                     else
                         return false;
                 case "cab2WithTrailer":
                     if ((netWeight > 0 && trailerWeight > 0) ||
                         (cab2SoloWeight > 0 && trailerWeight > 0))
                         return true;
                     else
                         return false;
                 case "trailer":
                     if ((cab2WTrailerWeight > 0 && cab2SoloWeight > 0) ||
                         (cab1WTrailerWeight > 0 && cab1SoloWeight > 0))
                         return true;
                     else
                         return false;
                 case "cab1WithTrailer":
                     if ((netWeight > 0 && trailerWeight > 0) ||
                         (cab1SoloWeight > 0 && trailerWeight > 0))
                         return true;
                     else
                         return false;
                 case "net":
                     if ((grossWeight > 0 && cab2WTrailerWeight > 0) ||
                         (grossWeight > 0 && cab1WTrailerWeight > 0) ||
                         (grossWeight > 0 && cab1SoloWeight > 0 && cab1WTrailerWeight > 0) ||
                         (grossWeight > 0 && cab2SoloWeight > 0 && cab2WTrailerWeight > 0))
                         return true;
                     else
                         return false;
             }
         }

         function popWeightDialogBoxWeights(weightValues) {
             $("#lblHiddenlabel").hide();
             $("#btnHidden1").hide();
             $("#lblHiddenlabel2").hide();
             $("#lblHiddenUndo").hide();
             $("#btnHidden2").hide();
             $("#lblWeightQuestion").hide();


             var gross = weightValues[0];
             var cab1Solo = weightValues[1];
             var cab2Solo = weightValues[2];
             var cab2WithTrailer = weightValues[3];
             var trailer = weightValues[4];
             var net = weightValues[5];
             var cab1WithTrailer = weightValues[11];

             var grossObtainMethod = weightValues[6];
             var cab1ObtainMethod = weightValues[7];
             var cab2ObtainMethod = weightValues[8];
             var cab2WithTrailerObtainMethod = weightValues[9];
             var trailerObtainMethod = weightValues[10];
             var cab1WithTrailerObtainMethod = weightValues[12];


             popGrossShowAndHideWeight(gross, grossObtainMethod);
             popCab1ShowAndHideWeight(cab1Solo, cab1ObtainMethod);
             popCab2ShowAndHideWeight(cab2Solo, cab2ObtainMethod);
             popCab2withTrailerShowAndHideWeight(cab2WithTrailer, cab2WithTrailerObtainMethod);
             popCab1withTrailerShowAndHideWeight(cab1WithTrailer, cab1WithTrailerObtainMethod);
             popTrailerShowAndHideWeight(trailer, trailerObtainMethod);
             popNetShowAndHideWeight(net);

             PageMethods.checkIfManualEntryIsEnabled(onSuccess_checkIfManualEntryIsEnabled, onFail_checkIfManualEntryIsEnabled, net);
         }


         function onClick_setManualWeight(weightnumType) {
             var strNewWeight = prompt("Enter weight in pounds: ", "0");
             if (strNewWeight) {
                 var fNewWeight = parseFloat(strNewWeight.replace(/[^\d\.]/g, ''));
                 if (isNaN(fNewWeight) || fNewWeight <= 0) {
                     alert("Please enter a valid weight");
                 }
                 else {
                     var response = confirm("Continue saving new weight of " + fNewWeight + " pounds ?");
                     if (response) {
                         var MSID = $("#weightDialogBox").data("data-MSID");
                         var weightData = [MSID, weightnumType, fNewWeight];
                         <%--pagemethod manual save of weight using --%>
                         PageMethods.updateWeightManually(MSID, weightnumType, fNewWeight, onSuccess_updateWeightManually, onFail_updateWeightManually, weightData);
                     }
                 }
             }
         }

         function onclick_toCOFAWithFilter(PO) {
             sessionStorage.setItem('PO', PO);
             location.href = 'COFAUpload.aspx';
         }

         function onClick_calculateNetDialog() {
             onClick_calcWeight(6);
         }

         function onClick_PopStatusBasedOnLocation(newLocation) {
             GLOBAL_STATUS_OPTIONS = [];
             var statusTextForDock;
             var statusID = $("#grid").data("data-StatID"); <%--current statusID --%>
             var statusText = $("#grid").data("data-StatText"); <%--current statusText --%>
             var MSID = $("#grid").data("data-MSID");
             GLOBAL_STATUS_OPTIONS.push({ "STATUS": currentStatusID, "STATUSTEXT": currentStatusText });
             var currentLocation = GLOBAL_GRID_DATA[findDatasetFromMSID(MSID)].LOCATION;


             switch (newLocation) {<%--populates with previous status, with the exception if the trucks status is currently not in one of the listed status below, then the only options will be to leave the status as is or to move it to GOS (Guard station out) - AJ --%>
                 case "NOS":
                     if (currentLocation == "GS" && statusID == 2) {<%--if currently checked in to GS --%>
                         GLOBAL_STATUS_OPTIONS.push({ "STATUS": 1, "STATUSTEXT": "Not Arrived" });
                     }
                     else {
                         GLOBAL_STATUS_OPTIONS.push({ "STATUS": 10, "STATUSTEXT": "Departed" });
                     }
                     break;
                 case "GS":
                     if (currentLocation == "NOS" && statusID == 1) {<%--if a truck hasnt arrived--%>
                         GLOBAL_STATUS_OPTIONS.push({ "STATUS": 2, "STATUSTEXT": "Arrived" });
                     }
                     else {
                         GLOBAL_STATUS_OPTIONS.push({ "STATUS": 10, "STATUSTEXT": "Departed" });
                     }
                     break;
                 case "WAIT":
                     GLOBAL_STATUS_OPTIONS.push({ "STATUS": 5, "STATUSTEXT": "Waiting" });
                     break;
                 case "DOCKBULK":
                     statusTextForDock = "Docked in: " + GLOBAL_GRID_DATA[findDatasetFromMSID(MSID)].DOCKSPOT;
                     GLOBAL_STATUS_OPTIONS.push({ "STATUS": 5, "STATUSTEXT": statusTextForDock });
                     break;
                 case "DOCKVAN":
                     statusTextForDock = "Docked in: " + GLOBAL_GRID_DATA[findDatasetFromMSID(MSID)].DOCKSPOT;
                     GLOBAL_STATUS_OPTIONS.push({ "STATUS": 5, "STATUSTEXT": statusTextForDock });
                     break;
                 default:
                     GLOBAL_STATUS_OPTIONS.push({ "STATUS": 10, "STATUSTEXT": "Departed" });
                     break;

             }
             $("#cboxStatus").igCombo("option", "dataSource", GLOBAL_STATUS_OPTIONS);
             $("#cboxLocation").igCombo("dataBind"); <%--rebind combobox--%>
             $("#cboxLocation").igCombo("value", statusID);
         }
         function onClick_CheckOut(MSID, PO, StatusID) {
             $("#grid").data("data-MSID", MSID);
             $("#grid").data("data-StatusID", StatusID);

             var Trailer = $("#grid").igGrid("getCellValue", MSID, "TRAILER");
             var c;
             var docVeri = $("#grid").igGrid("getCellValue", MSID, "DOCVERI");
             var isDropTrailer = $("#grid").igGrid("getCellValue", MSID, "isDROPTRAILER");
             if (!checkNullOrUndefined(docVeri)) {
                 if (isDropTrailer == 'No') {
                     if (!checkNullOrUndefined(Trailer)) {
                         c = confirm("You are about to check out PO # " + PO + " with trailer # " + Trailer + ". Would you like to continue checking out?");
                     }
                     else {
                         c = confirm("You are about to check out PO # " + PO + ". Would you like to continue checking out?");
                     }
                     if (c == true) {
                         $("#grid").data("data-MSID", MSID);
                         onclick_OpenMoreDetails(StatusID, MSID, true, false);
                         //PageMethods.CheckCurrentStatus(MSID, onSuccess_CheckCurrentStatus_CheckInCheckOutAndUndos, onFail_CheckCurrentStatus, "Out");
                     }
                 }
                 else {
                     onclick_OpenMoreDetails(StatusID, MSID, true, false);
                     //PageMethods.checkIfTrailerDropped(MSID, onSuccess_checkIfTrailerDropped, onFail_checkIfTrailerDropped, MSID);
                 }

             }
             else {
                 alert("Documents must be verified before check out.");
             }
         }
         function onClick_CheckIn(MSID, StatusID) {
             $("#grid").data("data-MSID", MSID);
             $("#grid").data("data-StatusID", StatusID);
             PageMethods.CheckCurrentStatus(MSID, onSuccess_CheckCurrentStatus_CheckInCheckOutAndUndos, onFail_CheckCurrentStatus, "In");
             //PageMethods.checkIn(MSID, onSuccess_checkIn, onFail_checkIn, MSID);
         }

         function undoCheckOut(MSID) {
             $("#undoCheckOutLocationDialogBox").data("data-MSID", MSID);
             PageMethods.getUndoLocationOptions(MSID, onSuccess_getUndoLocationOptions, onFail_getUndoLocationOptions, MSID);
         }
         function undoCheckIn(MSID) {
             $("#grid").data("data-MSID", MSID);
             PageMethods.CheckCurrentStatus(MSID, onSuccess_CheckCurrentStatus_CheckInCheckOutAndUndos, onFail_CheckCurrentStatus, "uIn");
         }

         function onClick_SetVerify(MSID) {
             //var PO = GLOBAL_GRID_DATA[findDatasetFromMSID(MSID)].PO;
             var status = $("#grid").igGrid("getCellValue", MSID, "STATUS");
             if (status != 'NOS') {
                 PageMethods.setVerify(MSID, onSuccess_setVerify, onFail_setVerify);
             }
             else {
                 alert("This truck has been released and its entry can no longer be edited.");
             }
         }
         function undoVerify(MSID) {
             //var PO = GLOBAL_GRID_DATA[findDatasetFromMSID(MSID)].PO;
             var status = $("#grid").igGrid("getCellValue", MSID, "STATUS");
             if (status != 'NOS') {
                 PageMethods.undoVerify(MSID, onSuccess_undoVerify, onFail_undoVerify);
             }
             else {
                 alert("This truck has been released and its entry can no longer be edited.");
             }
         }

         <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
         function formatStatusCombo(val) {
             var i, stat;
             for (i = 0; i < GLOBAL_STATUS_OPTIONS.length; i++) {
                 stat = GLOBAL_STATUS_OPTIONS[i];
                 if (stat.STATUS == val) {
                     val = stat.STATUSTEXT;
                 }
             }
             return val;
         }
         function formatLocationCombo(val) {
             var i, loc;
             for (i = 0; i < GLOBAL_LOCATION_OPTIONS.length; i++) {
                 loc = GLOBAL_LOCATION_OPTIONS[i];
                 if (loc.LOCATION == val) {
                     val = loc.LOCATIONTEXT;
                 }
             }
             return val;
         }
         function onClick_getWeights(MSID) {
             $("#lblWeightQuestion").hide();
             PageMethods.checkIfTrailerDropped(MSID, onSuccess_checkIfTrailerDropped_WeightsDisplay, onFail_checkIfTrailerDropped, MSID);
         }

         function onClick_GrossWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.launchAppAndUpdateWeight(MSID, "GROSS", onSuccess_launchAppAndUpdateWeight, onFail_launchAppAndUpdateWeight, MSID);
         }

         function onClick_Cab1Weight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.launchAppAndUpdateWeight(MSID, "C1", onSuccess_launchAppAndUpdateWeight, onFail_launchAppAndUpdateWeight, MSID);
         }

         function onClick_Cab2Weight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.launchAppAndUpdateWeight(MSID, "C2", onSuccess_launchAppAndUpdateWeight, onFail_launchAppAndUpdateWeight, MSID);
         }

         function onClick_Cab2wTrailerWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.launchAppAndUpdateWeight(MSID, "C2+", onSuccess_launchAppAndUpdateWeight, onFail_launchAppAndUpdateWeight, MSID);
         }

         function onClick_Cab1wTrailerWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.launchAppAndUpdateWeight(MSID, "C1+", onSuccess_launchAppAndUpdateWeight, onFail_launchAppAndUpdateWeight, MSID);
         }

         function onClick_TrailerWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.launchAppAndUpdateWeight(MSID, "T", onSuccess_launchAppAndUpdateWeight, onFail_launchAppAndUpdateWeight, MSID);
         }

         function validatePhoneNumber(pNumber) {
             var reg = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
             return reg.test(pNumber);
         }

         function onClick_SendToYard() {
             
             var MSID = $("#MoreDetailsDialog").data("data-MSID");
             PageMethods.verifyAndMove(MSID, "yard", onSuccess_verifyAndMove, onFail_verifyAndMove, "yard");
         }
         function onClick_SendToWaitingArea() {
             
             var MSID = $("#MoreDetailsDialog").data("data-MSID" );
             PageMethods.verifyAndMove(MSID, "wait", onSuccess_verifyAndMove, onFail_verifyAndMove, "wait");
         }
         function onclick_OpenMoreDetails(currentStatus, MSID, isCheckOut, isLimitedView) {

             if (isLimitedView) {

                 $("#FilesDetails").show();
                 $("#DriverDetails").hide();
                 $("#WeightDetails").hide();
                 $("#SendToAreaDetails").hide();

                 $("#btnSaveMoreDetails").hide();
                 $("#btnCloseMoreDetails").show();
                 

             
             }
             else {
                 $("#FilesDetails").show();
                 $("#DriverDetails").show();
                 $("#WeightDetails").show();
                 $("#SendToAreaDetails").show();
                 $("#FilesDetails").show();
                 $("#btnSaveMoreDetails").show();
                 $("#btnCloseMoreDetails").hide();

             }
             
             

             $("#MoreDetailsDialog").data("data-isCheckOut", isCheckOut);
                $("#MoreDetailsDialog").igDialog("option", "headerText", headerString);
                $("#MoreDetailsDialog").data("data-MSID", MSID);

                //Get datasource information
                var index = searchDataSourceByMSID(MSID);
                var headerString = "Details for PO# " + GLOBAL_GRID_DATA[index].PO + " Trailer# " + trailerNum;

                $("#dwFileUpload span.anr_t:contains('Add new row')").text("Add new file"); <%-- change label on grid --%>
                $('#dwFileUpload td[title="Click to start adding new row"]').attr('title', "Click to start adding new file");
                PageMethods.GetFileUploadsFromMSID(MSID, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, MSID);

             if (currentStatus === "READONLY") {
                 
                $("#MoreDetailsDialog").igDialog("option", "height", '500px');
                $("#MoreDetailsDialog").igDialog("open");
             }
             else {
                 
                $("#MoreDetailsDialog").igDialog("option", "height", '1055px');
                 onClick_getWeights(MSID);

                 var trailerNum = "";

                 if (checkNullOrUndefined(GLOBAL_GRID_DATA[index].TRAILER)) {
                     trailerNum = "N/A";
                 }
                 else {
                     trailerNum = GLOBAL_GRID_DATA[index].TRAILER;
                 }

                  
                 $("#weightDialogBox").data("data-MSID", MSID);

                 var dName = "";
                if (!checkNullOrUndefined(GLOBAL_GRID_DATA[index].DRIVERNAME)) {
                     dName = GLOBAL_GRID_DATA[index].DRIVERNAME;
                 }

                 var dNumber = "";
                 if (!checkNullOrUndefined(GLOBAL_GRID_DATA[index].DRIVERPHONENUMBER)) {
                     dNumber = GLOBAL_GRID_DATA[index].DRIVERPHONENUMBER;
                 }
                 var truckNumber = GLOBAL_GRID_DATA[index].CAB1NUM;
                 var trailerNumber = GLOBAL_GRID_DATA[index].TRAILER;
             
                 $("#txtMoreDriverName").val(dName);
                 $("#txtMoreDriverPhone").val(dNumber);
                 $("#txtMoreTruckNumber").val(truckNumber);
                 $("#txtMoreTrailerNumber").val(trailerNumber);



                 var buttonPressed = $("#weightDialogBox").data("data-ButtonPressed");
                 $("#weightOptionsIn").hide();
                 $("#weightOptionsOut").hide();
                 $("#weightOptionsTrailer").hide();
                 $("#lblWeightQuestion").hide();
             
                 if (currentStatus == "NOS") {
                     $("#weightDialogBox").data("data-NOS", true);
                     <%--hide all buttons since weight cant be updated--%>
                     //console buttons
                     $("#btnInGrossWeight").hide();
                     $("#btnInCab1Weight").hide();
                     $("#btnInCab1wTrailerWeight").hide();
                     $("#btnInCab2Weight").hide();
                     $("#btnOutCab1Weight").hide();
                     $("#btnOutCab1wTrailerWeight").hide();
                     $("#btnOutGrossWeight").hide();
                     $("#btnOutCab2wTrailerWeight").hide();
                     $("#btnTrailerWeight").hide();


                     //undo buttons
                     $("#undoInGrossWeight").hide();
                     $("#undoInCab1Weight").hide();
                     $("#undoInCab1wTrailerWeight").hide();
                     $("#undoCab2wTrailerWeight").hide();
                     $("#undoInCab2Weight").hide();
                     $("#undoOutCab1Weight").hide();
                     $("#undoOutCab1wTrailerWeight").hide();
                     $("#undoOutGrossWeight").hide();
                     $("#undoOutCab2wTrailerWeight").hide();
                     $("#undoTrailerWeight").hide();

                     //manual buttons
                     $("#btnInManualGrossWeight").hide();
                     $("#btnInManualCab1Weight").hide();
                     $("#btnInManualCab1wTrailerWeight").hide();
                     $("#btnInManualCab2Weight").hide();
                     $("#btnOutManualCab1Weight").hide();
                     $("#btnOutManualCab1wTrailerWeight").hide();
                     $("#btnOutManualGrossWeight").hide();
                     $("#btnOutManualCab2wTrailerWeight").hide();
                     $("#btnManualTrailerWeight").hide();

                     //calc buttons
                     $("#btnInCalCab1").hide();
                     $("#btnInCalCab1wTrailer").hide();
                     $("#btnInCalCab2").hide();
                     $("#btnOutCalCab1").hide();
                     $("#btnCalNet").hide();
                     $("#btnOutCalCab1wTrailer").hide();
                     $("#btnOutCalCab2wTrailer").hide();
                     $("#btnCalcTrailer").hide();

                     alert("Truck is no longer on site and weights can not be updated.");
                 }
                 else {
                     restoreToCorrectWeightDisplayAfterRepop(buttonPressed);
                     $("#weightDialogBox").data("data-NOS", false);
                 }

                // $("#weightDialogBox").igDialog("open");
                 $("#btnCalcNet").html("Recalculate Net");
             
             
                 $("#RightWeightSection").css("border", "");
             
                 $("#MoreDetailsDialog").igDialog("open");
             } //end else
         } <%-- end onclick_OpenMoreDetails --%>
         
         function onClick_CloseMoreDetails() {

            
             $("#txtMoreDriverName").val("");
             $("#txtMoreDriverPhone").val("");
             $("#txtMoreTruckNumber").val("");
             $("#txtMoreTrailerNumber").val("");

             
             $("#MoreDetailsDialog").igDialog("close");
         }


         <%--function onClick_OpenDetailsDialogBox(MSID) {
             $("#detailsDialog").data("data-MSID", MSID);
             $("#dwFileUpload span.anr_t:contains('Add new row')").text("Add new file"); 
             $('#dwFileUpload td[title="Click to start adding new row"]').attr('title', "Click to start adding new file");
             PageMethods.GetFileUploadsFromMSID(MSID, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, MSID);

             var index;
             var dName = "";
             var dNumber = "";
             var trailerNum;
             var GSComment = "";
             var headerString;
             var Cab1Num;
             var Cab2Num;
             index = searchDataSourceByMSID(MSID);

             if (checkNullOrUndefined(GLOBAL_GRID_DATA[index].TRAILER)) {
                 trailerNum = "N/A";
             }
             else {
                 trailerNum = GLOBAL_GRID_DATA[index].TRAILER;
             }

             headerString = "Details for PO# " + GLOBAL_GRID_DATA[index].PO + " Trailer# " + trailerNum;
             $("#detailsDialog").igDialog("option", "headerText", headerString);

             if (!checkNullOrUndefined(GLOBAL_GRID_DATA[index].DRIVERNAME)) {
                 dName = GLOBAL_GRID_DATA[index].DRIVERNAME;
             }
             $("#txtDriverName").val(dName);
             $("#txtDriverName").show();
             $("#lblDriverName").html("");
             $("#lblDriverName").hide();
             if (!checkNullOrUndefined(GLOBAL_GRID_DATA[index].DRIVERPHONENUMBER)) {
                 dNumber = GLOBAL_GRID_DATA[index].DRIVERPHONENUMBER;
             }
             $("#txtDriverPhone").val(dNumber);
             $("#txtDriverPhone").show();
             $("#lblDriverPhone").html("");
             $("#lblDriverPhone").hide();
             

             $("#btnSaveDriverInfo").show();
             $("#btnCancelDriverInfo").show();

             if (checkNullOrUndefined(GLOBAL_GRID_DATA[index].COMMENTS) == false) {
                 GSComment = GLOBAL_GRID_DATA[index].COMMENTS;
             }
             $("#txtAreaGSComment").val(GSComment);


             if (checkNullOrUndefined(GLOBAL_GRID_DATA[index].CAB1NUM) == false) {
                 Cab1Num = GLOBAL_GRID_DATA[index].CAB1NUM;
             }
             $("#txtCab1DetailsDialog").val(Cab1Num);

             if (checkNullOrUndefined(GLOBAL_GRID_DATA[index].CAB2NUM) == false) {
                 Cab2Num = GLOBAL_GRID_DATA[index].CAB2NUM;
             }
             $("#txtCab2DetailsDialog").val(Cab2Num);



             $("#detailsDialog").igDialog("open");


         }--%>


         function searchDataSourceByMSID(MSID) {
             for (var index = 0; index < GLOBAL_GRID_DATA.length; index++) {
                 if (GLOBAL_GRID_DATA[index].MSID === MSID) {
                     return index;
                 }
             }
         }

         function hasBeenGoneForOverAnHour(checkOutTime, MSID) {
             var CO_Time = new Date(checkOutTime);
             var now = new Date();
             var dateDiff = now - CO_Time;
             var oneHour = 3600000; <%--oneHour = 1000*60*60; --%>

             if (dateDiff > oneHour) {
                 return true;
             }
             else {
                 return false;
             }
         }
         function onClick_SaveGSCommentAndCabNumbers() {
             var MSID = $("#detailsDialog").data("data-MSID");
             var GSComment = $("#txtAreaGSComment").val();
             var cab1 = $("#txtCab1DetailsDialog").val();
             var cab2 = $("#txtCab2DetailsDialog").val();
             PageMethods.updateGSCommentAndCabNumbers(MSID, GSComment, cab1, cab2, onSuccess_updateGSCommentAndCabNumbers, onFail_updateGSCommentAndCabNumbers, GSComment);
         }

         function onClick_SaveDriverInfoAndClose() {
             var MSID = $("#MoreDetailsDialog").data("data-MSID");
             var driverName = $("#txtMoreDriverName").val()? $("#txtMoreDriverName").val(): "";
             var driverPhoneNumber =  $("#txtMoreDriverPhone").val()? $("#txtMoreDriverPhone").val(): "";
             var truckNumber = $("#txtMoreTruckNumber").val()? $("#txtMoreTruckNumber").val(): "";
             var trailerNumber = $("#txtMoreTrailerNumber").val()? $("#txtMoreTrailerNumber").val(): "";
             var arrayDriverInfo = [driverName, driverPhoneNumber, truckNumber, trailerNumber];
             
             var index = searchDataSourceByMSID(MSID);

           
             var isValidPhoneNumber;
             if (!checkNullOrUndefined(driverPhoneNumber) ) {
                 isValidPhoneNumber = validatePhoneNumber(driverPhoneNumber);
             }
             
             var continueUpdate = false;
             if (!isValidPhoneNumber) {
                continueUpdate = confirm("Phone number does not appear to be valid. Continue saving information anyways?")
             }
             if (isValidPhoneNumber == true || continueUpdate) {
                 PageMethods.updateDriverInfo(MSID, driverName, driverPhoneNumber, trailerNumber, truckNumber, onSuccess_updateDriverInfo, onFail_updateDriverInfo, arrayDriverInfo);
             }
             else {
                 alert("Phone number is not valid");
             }
             
         }

         function onClick_CloseDriverInfo() {
             $("#detailsDialog").data("data-MSID", "");
             $("#detailsDialog").igDialog("close");
         }


         function onClick_undoGrossWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.undoGrossWeight(MSID, onSuccess_undoGrossWeight, onFail_undoGrossWeight);
         }
         function onClick_undoCab1Weight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.undoCab1Weight(MSID, onSuccess_undoCab1Weight, onFail_undoCab1Weight);
         }
         function onClick_undoCab2Weight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.undoCab2Weight(MSID, onSuccess_undoCab2Weight, onFail_undoCab2Weight);
         }
         function onClick_undoCab2wTrailerWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.undoCab2wTrailerWeight(MSID, onSuccess_undoCab2wTrailerWeight, onFail_undoCab2wTrailerWeight);
         }
         function onClick_undoCab1wTrailerWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.undoCab1wTrailerWeight(MSID, onSuccess_undoCab1wTrailerWeight, onFail_undoCab1wTrailerWeight);
         }
         function onClick_undoTrailerWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.undoTrailerWeight(MSID, onSuccess_undoTrailerWeight, onFail_undoTrailerWeight);
         }
         function onClick_undoNetWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.undoNetWeight(MSID, onSuccess_undoNetWeight, onFail_undoNetWeight);
         }

         function onclick_addFile(fupID) {
             $(fupID).click();
         }

         function onclick_deleteFile(fid) {
             r = confirm("Continue removing this file from the truck data? This cannot be undone.")
             if (r) {
                 var msid = $('#MoreDetailsDialog').data("data-MSID");
                 PageMethods.DeleteFileDBEntry(fid, "OTHER", msid, onSuccess_DeleteFileDBEntry, onFail_DeleteFileDBEntry, "OTHER");
             }
         }
         function onclick_deleteBOL() {
             r = confirm("Continue removing the BOL from the truck data? This cannot be undone.")
             if (r) {
                 var fid = $('#dBOLcontainer').data("data-fileID");
                 var msid = $('#MoreDetailsDialog').data("data-MSID");
                 PageMethods.DeleteFileDBEntry(fid, "BOL", msid, onSuccess_DeleteFileDBEntry, onFail_DeleteFileDBEntry, "BOL");
             }
         }
         function onclick_deleteCOFA() {
             r = confirm("Continue removing the COFA from the truck data? This cannot be undone.")
             if (r) {
                 var fid = $('#dCOFAcontainer').data("data-fileID");
                 var msid = $('#MoreDetailsDialog').data("data-MSID");
                 PageMethods.DeleteFileDBEntry(fid, "COFA", msid, onSuccess_DeleteFileDBEntry, onFail_DeleteFileDBEntry, "COFA");
             }
         }



         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
         function initGrid() {
             $("#grid").igGrid({
                 dataSource: GLOBAL_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 renderCheckboxes: true,
                 primaryKey: "MSID",
                 autofitLastColumn: true,
                 columns:
                     [

                         { headerText: "", key: "BoolIsOpenInCMS", datatype: "boolean", width: "0px", hidden: true },
                         { headerText: "", key: "MSID", dataType: "number", width: "0px",hidden: true },
                         { headerText: "", key: "MSIDTEXT", dataType: "string", width: "0px",hidden: true },
                         { headerText: "", key: "PO", dataType: "number", width: "0px",hidden: true },
                         {
                             headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED})}}" +
                              "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}", width: "70px"
                         },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", dataType: "string", width: "50px" },
                         { headerText: "PO", key: "POTEXT", dataType: "string", width: "90px" },
                         { headerText: "Customer Order#", key: "ZXPPONUM", dataType: "string", width: "90px" },
                         {
                             headerText: "Product", key: "PRODID", dataType: "string", width: "150px",
                             template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                                        "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                                        "{{else}}Multiple{{/if}}"
                         },
                        { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
                        {
                            headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px",
                            template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                                    "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                                    "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialog(${MSID}); return false;'></div>{{/if}}"
                        },
                         { headerText: "Drop Trailer", key: "isDROPTRAILER", dataType: "string", width: "70px" },
                         { headerText: "ETA", key: "ETA", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "120px" },
                         { headerText: "Load", key: "LOADTYPE", dataType: "string", width: "50px" },
                         { headerText: "Truck Type", key: "TRUCKTYPE", dataType: "string", width: "65px" },
                         { headerText: "Location", key: "LOCATION", dataType: "string", formatter: formatLocationCombo, width: "75px" },
                         { headerText: "Status", key: "STATUS", dataType: "string", formatter: formatStatusCombo, width: "100px" },
                         { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "75px" },
                         { headerText: "Cab In/1 #", key: "CAB1NUM", dataType: "string", width: "0px", hidden: true },
                         { headerText: "Cab Out/2 #", key: "CAB2NUM", dataType: "string", width: "0px", hidden: true },
                         {
                             headerText: "Check In", key: "CHECKIN", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "85px",
                             template: "{{if(checkNullOrUndefined(${CHECKIN})) === true}} <div class ='ColumnContentExtend'> <input id='btnCheckIn' type='button' value='Check In' onclick='onClick_CheckIn(${MSID}, ${STATUS});' class='ColumnContentExtend'/></div>" +
                                        "{{elseif (checkNullOrUndefined(${CHECKIN})) === false && ${LOCATION} === 'GS'  && (hasBeenGoneForOverAnHour(${CHECKIN})) === false }} <div class ='ColumnContentExtend'>${CHECKIN} <span class='Mi4_undoIcon' onclick='undoCheckIn(${MSID})'></span> </div>" +
                                        "{{else}} <div class ='ColumnContentExtend'>${CHECKIN}</div>{{/if}}"
                         },
                         {
                             headerText: "Check Out", key: "CHECKOUT", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "85px",
                             template: "{{if(checkNullOrUndefined(${CHECKOUT})) === true && (checkNullOrUndefined(${CHECKIN})) === false}}<div class ='ColumnContentExtend'><input id='btnCheckOut' type='button' value='Check Out' onclick='onClick_CheckOut(${MSID}, ${PO},${STATUS} );' class='ColumnContentExtend'/></div>" +
                                        "{{elseif (checkNullOrUndefined(${CHECKIN})) === false && (checkNullOrUndefined(${CHECKOUT})) === false && (hasBeenGoneForOverAnHour(${CHECKOUT})) === false}}<div class ='ColumnContentExtend'>${CHECKOUT}<span class='Mi4_undoIcon' onclick='undoCheckOut(${MSID})'></span></div>" +
                                        "{{elseif (checkNullOrUndefined(${CHECKIN})) === false && (checkNullOrUndefined(${CHECKOUT})) === false && (hasBeenGoneForOverAnHour(${CHECKOUT})) === true}}<div class ='ColumnContentExtend'>${CHECKOUT}</div>" + "{{else}}<div> </div>{{/if}}"
                         },

                         {
                             headerText: "Docs Verified", key: "DOCVERI", dataType: "string", width: "75px", template: "{{if (checkNullOrUndefined(${DOCVERI})) == true && (checkNullOrUndefined(${CHECKIN}) == false) && (checkNullOrUndefined(${CHECKOUT}) == true)}} <div class ='ColumnContentExtend'> <input id='btnVerify' type='button' value='Verified' onclick='onClick_SetVerify(${MSID});' class='ColumnContentExtend'/> </div> " +
                                 "{{elseif (checkNullOrUndefined(${DOCVERI})) == false}}<div class ='ColumnContentExtend'><img src='Images/CheckMark.gif' height='16' width='16'/> <span class='Mi4_undoIcon' onclick='undoVerify(${MSID})'> </span> </div> {{/if}}"
                         },

                         {
                             headerText: "Details", key: "POPUPWINDOW", dataType: "string", width: "85px",
                             template: "{{if (checkNullOrUndefined(${CHECKIN}) == false)}} <div class ='ColumnContentExtend'><div class=\"tooltip\">" +
                                 "<input id='btnPopUpDetails' type='button' value='More Details' onclick='onclick_OpenMoreDetails(${STATUS}, ${MSID}, false, false);' class='ColumnContentExtend' /> <span class=\"tooltiptext\">More information</span><\div></div>" +
                             " {{else}} <div class ='ColumnContentExtend'><div class=\"tooltip\">" +
                                 "<input id='btnPopUpDetails' type='button' value='More Details' onclick='onclick_OpenMoreDetails(\"READONLY\", ${MSID}, false, true);' class='ColumnContentExtend' /> <span class=\"tooltiptext\">More information</span><\div></div>{{/if}} "
                         },
                         { headerText: "Comments (max. 250)", key: "COMMENTS", dataType: "string", width: "0px", hidden: true }

                     ],
                 features: [
                     {
                         name: 'Paging'
                     },
                     {
                         name: 'Resizing'
                     },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          editMode: "row",
                          enableDeleteRow: false,
                          validation: true,
                          showReadonlyEditors: false,
                          enableDataDirtyException: false,
                          autoCommit: false,
                          editRowStarting: function (evt, ui) {
                              <%--stop editing if truck is NOS, button are handled different and will still function--%>
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.LOCATION == "NOS") {
                                  return false;
                              }

                              <%--stop editing if button was clicked instead of cell entry for editing--%>
                              var isUploadBtnClicked = $("#grid").data("data-BUTTONClick");
                              if (isUploadBtnClicked) {
                                  $("#grid").data("data-BUTTONClick", false);
                                  return false;
                              }

                               row = ui.owner.grid.findRecordByKey(ui.rowID);
                              $("#grid").data("data-MSID", ui.rowID);
                              //PageMethods.GetLogDataByMSID(ui.rowID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ui.rowID);
                          },
                          editRowEnding: function (evt, ui) {
                              var origEvent = evt.originalEvent;
                              if (typeof origEvent === "undefined") {
                                  ui.keepEditing = true;
                                  return false;
                              }
                              if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                  //var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                  //$("#grid").data("data-MSID", ui.values.MSIDTEXT);
                                  var contextParam = [];
                                  contextParam["MSID"] = ui.rowID;
                                  contextParam["TrailerNum"] = ui.values.TRAILER;

                                  PageMethods.checkIfCanUpdateTrailerNumber(ui.rowID, ui.values.TRAILER, onSuccess_checkIfCanUpdateTrailerNumber, onFail_checkIfCanUpdateTrailerNumber, contextParam);
                              }
                              else {

                                  if ((origEvent.type == "mousedown" || origEvent.type !== "click") && !origEvent.currentTarget.innerText.toUpperCase() === 'CANCEL') {
                                      ui.keepEditing = true;
                                  }
                                  return false;
                              }
                          },
                          columnSettings:
                              [
                                { columnKey: "TOWAITINGAREA", readOnly: true },
                                { columnKey: "PRODCOUNT", readOnly: true },
                                { columnKey: "PRODID", readOnly: true },
                                { columnKey: "PRODDETAIL", readOnly: true },
                                { columnKey: "BoolIsOpenInCMS", readOnly: true },
                                { columnKey: "MSID", readOnly: true },
                                { columnKey: "MSIDTEXT", readOnly: true },
                                { columnKey: "isDROPTRAILER", readOnly: true },
                                { columnKey: "isOpenInCMS", readOnly: true },
                                { columnKey: "PO", readOnly: true },
                                { columnKey: "POTEXT", readOnly: true },
                                { columnKey: "ETA", readOnly: true },
                                { columnKey: "CHECKIN", readOnly: true },
                                { columnKey: "CHECKOUT", readOnly: true },
                                { columnKey: "WEIGHTS", readOnly: true },
                                { columnKey: "REJECTED", readOnly: true },
                                { columnKey: "TRUCKTYPE", readOnly: true },
                                { columnKey: "LOADTYPE", readOnly: true },
                                { columnKey: "DOCVERI", readOnly: true },
                                { columnKey: "DRIVERINFO", readOnly: true },
                                { columnKey: "ZXPPONUM", readOnly: true },
                                { columnKey: "POPUPWINDOW", readOnly: true },
                                {
                                    columnKey: "LOCATION",
                                    readOnly: true
                                },
                                {
                                    columnKey: "STATUS",
                                    readOnly: true
                                },
                                {
                                    columnKey: "TRAILER",
                                    editorType: "text",
                                    editorOptions: {
                                        maxLength: 15
                                    }
                                },
                                {
                                    columnKey: "COMMENTS",
                                    editorType: "text",
                                    editorOptions: {
                                        maxLength: 250
                                    }
                                }
                              ],
                          editCellEnded: function (evt, ui) {
                              $("#grid").igGrid("saveChanges");

                          }
                      },
                       {
                           name: "Filtering",
                           columnSettings: [
                                        { columnKey: 'ETA', condition: 'on' },
                                        { columnKey: 'CHECKIN', condition: 'on' },
                                        { columnKey: 'CHECKOUT', condition: 'on' },
                                        { columnKey: 'WEIGHTS', allowFiltering: false },
                                        { columnKey: 'DOCVERI', allowFiltering: false },
                                        { columnKey: 'DRIVERINFO', allowFiltering: false },
                                        { columnKey: 'TOWAITINGAREA', allowFiltering: false },
                           ],
                           dataFiltering: function (evt, ui) {

                               var nExpressions = [];
                               for (i = 0; i < ui.newExpressions.length; i++) {
                                   var newcond = ui.newExpressions[i].cond;
                                   var newExpr = ui.newExpressions[i].expr;
                                   var newFieldName = ui.newExpressions[i].fieldName;
                                   if (!checkNullOrUndefined(newExpr)) {
                                       if (newFieldName.contains("ETA") || newFieldName.contains("CHECKIN") || newFieldName.contains("CHECKOUT")) {
                                           ui.newExpressions[i].preciseDateFormat = null;
                                       }

                                       nExpressions.push(ui.newExpressions[i]);
                                   }

                               }
                               $("#grid").igGridFiltering("filter", nExpressions);
                               return false;
                           },
                       },
                       {
                           name: 'Sorting'
                       }
                 ]
             }); <%--end of $("#grid").igGrid({--%>
         };

         $(function () {             
             $("#WeightAppTag").hide();

             $(".arrowGridScrollButtons").show();
             $(document).delegate("#grid", "iggridcellclick", function (evt, ui) {

                 if (ui.colKey === 'DRIVERINFO' || ui.colKey === 'CHECKIN' || ui.colKey === 'CHECKOUT' || ui.colKey === 'DOCKVERI' || ui.colKey === 'WEIGHTS' || ui.colKey === 'TOWAITINGAREA') {
                     $("#grid").data("data-BUTTONClick", true);
                 }
                 else {
                     $("#grid").data("data-BUTTONClick", false);
                 }

             });

             var isMobile = isOnMobile();
             $("#logButton").click(function () {
                 var logDisplay = $('#logTableWrapper').css('display');
                 truckLog_MiniMaxAndRemember(logDisplay);
             });

             $("#undoCheckOutLocationDialogBox").igDialog({
                 width: "400px",
                 height: "250px",
                 state: "closed",
                 stateChanging: function (evt, ui) {
                 }


             });


             $("#cboxLocations").igCombo({
                 dataSource: null,
                 textKey: "LOCTEXT",
                 valueKey: "LOC",
                 width: "200px",
                 autoComplete: true,
                 enableClearButton: false,
                 selectionChanging: function (evt, ui) {
                     if (ui.items.length > 0) {
                         if (ui.items[0].data.LOC == 'DOCKVAN' || ui.items[0].data.LOC == 'DOCKBULK') {
                             $("#dockSpotOptionsWrapper").show();
                         }
                         else {
                             $("#dockSpotOptionsWrapper").hide();
                             $("#cboxDockSpots").igCombo("value", null);
                         }
                     }
                 }
             });

             $("#cboxDockSpots").igCombo({
                 dataSource: null,
                 textKey: "DOCKSPOT",
                 valueKey: "SPOTID",
                 width: "200px",
                 autoComplete: true,
                 enableClearButton: false
             });

             $("#gridFiles").igGrid({
                 dataSource: null,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 primaryKey: "FID",
                 columns:
                 [
                 { headerText: "", key: "FID", dataType: "number", width: "0%", hidden: true },
                 { headerText: "", key: "MSID", dataType: "number", width: "0%", hidden: true },
                 { headerText: "", key: "FPATH", dataType: "string", width: "0%", hidden: true },
                 { headerText: "", key: "FNAMENEW", dataType: "string", width: "0%", hidden: true },
                 { headerText: "Filename", key: "FNAMEOLD", dataType: "string", width: "30%", template: "<div><a href='${FPATH}\${FNAMENEW}'>${FNAMEOLD}</a></div>" },
                 { headerText: "Description", key: "DESC", dataType: "string", width: "60%" },
                 { headerText: "", key: "FUPDEL", dataType: "string", width: "10%", template: "<div><div><img src='Images/xclose.png' onclick='onclick_deleteFile(${FID});return false;' height='16' width='16'/></div></div>" },
                 ],
                 features:
                     [
                         {
                             name: "Updating",
                             enableAddRow: true,
                             editMode: "row",
                             enableDeleteRow: false, <%-- // use clickable image since this only shows on row hover --%>
                             rowEditDialogContainment: "owner",
                             showReadonlyEditors: false,
                             enableDataDirtyException: false,
                             autoCommit: false,
                             rowAdding: function (evt, ui) {
                                 if (ui.rowAdding) {
                                     var fpath = $("#gridFiles").data("data-FPath");
                                     var fnameNew = $("#gridFiles").data("data-FNameNew");
                                     var fnameOld = $("#gridFiles").data("data-FNameOld");
                                     if (fpath && fnameNew && fnameOld) {
                                        <%-- TODO: add code to insert new row with new file data --%>
                                         return true;
                                     }
                                     else {
                                        <%-- STOP Rowadded event --%>
                                         return false;
                                     }
                                 }
                             },
                             rowAdded: function (evt, ui) {



                                 var fpath = $("#gridFiles").data("data-FPath");
                                 var fnameNew = $("#gridFiles").data("data-FNameNew");
                                 var fnameOld = $("#gridFiles").data("data-FNameOld");
                                 var msid = $("#MoreDetailsDialog").data("data-MSID");
                                 var desc = ui.values.DESC;

                                 PageMethods.AddFileDBEntry(msid, "OTHER", fnameOld, fnameNew, fpath, desc, onSuccess_AddFileDBEntry, onFail_AddFileDBEntry);


                             },
                             editRowStarted: function (evt, ui) {
                                 if (ui.rowAdding) {
                                     onclick_addFile("#igUploadOTHER_ibb_fp");
                                 }
                                 else { <%--  do nothing; regular row is being edited --%>

                                 }
                             },
                             editRowEnding: function (evt, ui) {
                                <%-- change add new row's filename col back to blank column --%>
                                 $("#gridFiles tr").eq(2).find('td:first-child').text("");

                                 if (ui.rowAdding) { <%-- //new row edited --%>
                                     if (!ui.update) {
                                     }

                                 }
                                 else { <%-- //regular row is being edited --%>
                                     if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) { <%-- //regular row is being edited --%>
                                         var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                         PageMethods.UpdateFileUploadData(row.FID, ui.values.DESC, onSuccess_UpdateFileUploadData, onFail_UpdateFileUploadData);
                                     }
                                     else {
                                         return false;
                                     }
                                 }
                             },
                             columnSettings: [

                                 { columnKey: "FNAMEOLD", readOnly: true },
                                 { columnKey: "FUPDEL", readOnly: true },
                                 { columnKey: "DESC", editorType: "text" }

                             ]
                         },


                     ]
             });
             $("#cboxLogTruckList").igCombo({
                 dataSource: GLOBAL_LOG_OPTIONS,
                 textKey: "PO",
                 valueKey: "MSID",
                 width: "100%",
                 virtualization: true,
                 selectionChanged: function (evt, ui) {
                     if (ui.items.length == 1) {
                         //PageMethods.GetLogDataByMSID(ui.items[0].data.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ui.items[0].data.MSID);
                     }
                     else if (ui.items.length == 0) {
                         $("#tableLog").empty();
                     }
                 }
             });


             $("#detailsDialog").igDialog({
                 width: "700px",
                 height: "900px",
                 state: "closed",
                 closeOnEscape: true
             });
             $("#MoreDetailsDialog").igDialog({
                 width: "900px",
                 height: "1055px",
                 state: "closed",
                 closeOnEscape: true,
                 stateChanging: function (evt, ui) {
                     if (ui.action === "close") {
                         
                         $("#MoreDetailsDialog").removeData("data-isCheckOut");

                         $("#weightDialogBox").data("data-ButtonPressed", "");
                         $("#weightDialogBox").data("data-hasTrailerDropped", "");
                         $("#weightDialogBox").data("data-MSID", "");
                         $("#weightDialogBox").data("data-NOS", "");
                         $("#weightDialogBox").data("data-isDropTrailer", "");
                         $("#weightDialogBox").data("data-loadType", "");

                         $("#weightDialogBox").data("data-grossWeight", "");
                         $("#weightDialogBox").data("data-cab1SoloWeight", "");
                         $("#weightDialogBox").data("data-cab2SoloWeight", "");
                         $("#weightDialogBox").data("data-cab2WithTrailerWeight", "");
                         $("#weightDialogBox").data("data-trailerWeight", "");
                         $("#weightDialogBox").data("data-netWeight", "");
                         $("#weightDialogBox").data("data-cab1WithTrailerWeight", "");

                         $("#weightDialogBox").data("data-grossWeightMethod", "");
                         $("#weightDialogBox").data("data-cab1SoloWeightMethod", "");
                         $("#weightDialogBox").data("data-cab2SoloWeightMethod", "");
                         $("#weightDialogBox").data("data-cab2WithTrailerWeightMethod", "");
                         $("#weightDialogBox").data("data-trailerWeightMethod", "");
                         $("#weightDialogBox").data("data-cab1WithTrailerWeightMethod", "");
                     }
                 }
             });


             $("#igUploadBOL").igUpload({
                 autostartupload: true,
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelecting: function (evt, ui) { },
                 fileSelected: function (evt, ui) { showProgress(); },
                 fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                     var ctxVal = [];
                     var MSID = $("#MoreDetailsDialog").data("data-MSID");
                     ctxVal[0] = ui.filePath;
                     ctxVal[1] = "BOL";
                     ctxVal[2] = MSID;
                     PageMethods.ProcessFileAndData(ui.filePath, "BOL", onSuccess_ProcessFileAndData, onFail_ProcessFileAndData, ctxVal);
                     hideProgress();
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },
                 onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in guardStation.aspx, igUploadBOL"); },

             });

             $("#igUploadCOFA").igUpload({
                 autostartupload: true,
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelecting: function (evt, ui) { },
                 fileSelected: function (evt, ui) { showProgress(); },
                 fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                     var ctxVal = [];
                     var MSID = $("#MoreDetailsDialog").data("data-MSID");
                     ctxVal[0] = ui.filePath;
                     ctxVal[1] = "COFA";
                     ctxVal[2] = MSID;
                     PageMethods.ProcessFileAndData(ui.filePath, "COFA", onSuccess_ProcessFileAndData, onFail_ProcessFileAndData, ctxVal);
                     hideProgress();
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },
                 onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in guardStation.aspx, igUploadCOFA"); },

             });


             $("#igUploadOTHER").igUpload({
                 autostartupload: true,
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelecting: function (evt, ui) { },
                 fileSelected: function (evt, ui) { showProgress(); },
                 fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                     var ctxVal = [];
                     var MSID = $("#MoreDetailsDialog").data("data-MSID");
                     ctxVal[0] = ui.filePath;
                     ctxVal[1] = "OTHER";
                     ctxVal[2] = MSID;
                     PageMethods.ProcessFileAndData(ui.filePath, "OTHER", onSuccess_ProcessFileAndData, onFail_ProcessFileAndData, ctxVal);
                     hideProgress();
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },
                 onError: function (evt, ui) {
                     hideProgress();
                     sendtoErrorPage("Error in guardStation.aspx, igUploadOTHER");
                 },

             });

             $("#dwProductDetails").igDialog({
                 width: "650px",
                 height: "550px",
                 state: "closed",
                 modal: true,
                 draggable: false,
                 stateChanging: function (evt, ui) {
                 }
             });

             $("#gridPODetails").igGrid({
                 dataSource: null,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 primaryKey: "PODETAILID",
                 columns:
                 [
                 { headerText: "", key: "PODETAILID", dataType: "number", width: "0%", hidden: true },
                 { headerText: "CMS Product ID ", key: "CMSPROD", dataType: "string", width: "150px", },
                 { headerText: "CMS Product Name", key: "CMSPRODNAME", dataType: "string", width: "150px", },
                 { headerText: "QTY", key: "QTY", dataType: "number", width: "150px", },
                 { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px", },

                 ]
             });


             //PageMethods.GetLogList(onSuccess_GetLogList, onFail_GetLogList);
             PageMethods.GetStatusOptions(onSuccess_GetStatusOptions, onFail_GetStatusOptions);
         });

     </script>
    
    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="dvGridFilterButtons">
        <button type="button" onclick='onclick_ShowAllScheduledTrucks(); return false;'>Show All Trucks</button>
        <button type="button" onclick='onclick_ShowTodaysTrucks(); return false;'>Show Today's Trucks</button>
        <button type="button" onclick='onclick_ShowOpenInCMSButOutOfPlant(); return false;'>Show Released Trucks but Open In CMS </button>
    </div>
    <br />
    
    <div id ="undoCheckOutLocationDialogBox">
        <h2>Update Location</h2>
        <input id="cboxLocations" />
        <button type="button" id="btn_updateLocation" onclick='onclick_btnUpdateLocation();'>Update Location</button>
        <div id="dockSpotOptionsWrapper">
            <h2>Dock Spot</h2>
            <input id="cboxDockSpots" />
        </div>
    </div>

    <%--File upload controls--%>
    <div id="igUploadBOL" style='display: none;' ></div>
    <div id="igUploadCOFA" style='display: none;' ></div>
    <div id="igUploadOTHER" style='display: none;' ></div>

    
    <%-- Log --%>
    <div class="logWindow" style="display: none">
        <div class="logTitleBar">
            <div id="logButton">
                <div id="tLogMax" style="display:none"><img src='Images/tLogMaxi.png' id="maxiIcon" /></div>
                <div id="tLogMini" ><img src='Images/tLogMini.png' id="miniIcon"/></div></div>
            Truck Log
        </div>
        <div id="logTableWrapper">
            <input id="cboxLogTruckList" />
            <div id="tableLog"></div>
        </div>
    </div>

    <%--Dialog for driver info--%>
    <table id="grid" class="scrollGridClass"></table> 
     <div id="dwProductDetails">
        <h2><span>PO - Trailer:  <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>
        <a id="WeightAppTag" onclick="window.open('truckfilewriter:')" style="display:none;">Console app</a> <%--onclick="window.open('') href="" "--%>
    <div id ="MoreDetailsDialog">
          <div id="DriverDetails"  class ="detailBox">
            <h2>Enter Driver and Truck Info</h2>
        <table class="tblDriverInfo">
            <tr><td><label id="lblDriverNameMoreDetailsDialog" maxlength="50">Driver Name: </label></td>
                <td><input type="text" id="txtMoreDriverName" /></td>
                <td><label id="lblDriverPhoneMoreDetailsDialog"  maxlength="10" >Phone: </label></td>
                <td><input type="text" id="txtMoreDriverPhone" /></td>
            </tr>
            <tr><td><label id="lblTruckNumberMoreDetailsDialog"  maxlength="15">Cab/Truck Number: </label></td>
                <td><input type="text" id="txtMoreTruckNumber" /></td>
                <td><label id="lblTrailerNumberDetailsDialog"  maxlength="15">Trailer Number: </label></td>
                <td><input type="text" id="txtMoreTrailerNumber" /></td>

            </tr>
        </table>
        </div>
        <br />
          <div id="WeightDetails"  class ="detailBox">
            <div id ="weightDialogBox">
               <%-- <div class ="leftWeightDialog" id="weightButtonDialog">--%>
                <table>
                    <tr>
                        <td>
                            <div id="weightButtonDialog">
                                <%--<label id="lblChooseWeightOption">Choose a weight option:</label>--%>
                                <h2>Choose a weight option:</h2>
                                <table id="tblWeightButtonDialog">
                                    <tr><td><input type='button' id="WeighInButton" value='Weigh In' onclick='onClick_OpenWeighInDialogDiv();'></td></tr>
                                    <tr><td><input type='button' id="WeighTrailerOnlyButton" value='Weigh Trailer Only' onclick='onClick_OpenTrailerOnlyDialogDiv();'></td></tr>
                                    <tr><td><input type='button' id="WeighOutButton" value='Weigh Out' onclick='onClick_OpenWeighOutDialogDiv();'></td></tr>
                                </table>
                            </div>
                        </td>
                        <td id="RightWeightSection" >
                       <%-- <div class ="rightWeightDialog">--%>
                        <div>
                            <label id="lblWeightQuestion"></label>
                            <table id="weightOptionsIn">
                                <%--in--%>
                            <tr><td>
                                <label id="lblInGross">Cab 1, Trailer, & Product(s):</label><td><button type="button" id="btnInGrossWeight" onclick='onClick_GrossWeight()'>Get From Scale</button> 
                                <label id="lblInGrossWeight"></label></td>
                                <td><span id="undoInGrossWeight" class="Mi4_undoIcon" onclick="onClick_undoGrossWeight()"></span></td>
                                <td><button type="button" id="btnInManualGrossWeight" onclick='onClick_setManualWeight(1)'>Set Manually</button>
                                </td></tr>


                            <tr><td><label id="lblInCab1TextDialogBox">Cab 1 Only: </label></td>
                                <td><button type="button" id="btnInCab1Weight" onclick='onClick_Cab1Weight()'>Get From Scale</button><label id="lblInCab1Weight"></label></td>   
                                <td><span id="undoInCab1Weight" class="Mi4_undoIcon" onclick="onClick_undoCab1Weight()"></span></td>
                                <td><button type="button" id="btnInManualCab1Weight" onclick='onClick_setManualWeight(2)'>Set Manually</button></td>
                                <td><button type="button" id="btnInCalCab1" onclick='onClick_calcWeight(2)'>Calculate</button></td></tr>


                            <tr><td><label id="lblInCab1wTrailerTextDialogBox">Cab 1  w/ Trailer: </label></td>
                                <td><button type="button" id="btnInCab1wTrailerWeight" onclick='onClick_Cab1wTrailerWeight()'>Get From Scale</button><label id="lblInCab1wTrailerWeight"></label></td>  
                                <td><span id="undoInCab1wTrailerWeight" class="Mi4_undoIcon" onclick="onClick_undoCab1wTrailerWeight()"></span></td>
                                <td><button type="button" id="btnInManualCab1wTrailerWeight" onclick='onClick_setManualWeight(6)'>Set Manually</button></td>
                                <td><button type="button" id="btnInCalCab1wTrailer" onclick='onClick_calcWeight(7)'>Calculate</button></td></tr>

                
                            <tr><td><label id="lblInCab2TextDialogBox">Cab 2 Only: </label></td>
                                <td><button type="button" id="btnInCab2Weight" onclick='onClick_Cab2Weight()'>Get From Scale</button><label id="lblInCab2Weight"></label></td>   
                                <td><span id="undoInCab2Weight" class="Mi4_undoIcon" onclick="onClick_undoCab2Weight()"></span></td>
                                <td><button type="button" id="btnInManualCab2Weight" onclick='onClick_setManualWeight(3)'>Set Manually</button></td>
                                <td><button type="button" id="btnInCalCab2" onclick='onClick_calcWeight(3)'>Calculate </button></td></tr>
                
                                </table>
                                <%--out--%>
                            <table id="weightOptionsOut">
                                <tr><td><label id="lblOutCab1TextDialogBox">Cab 1 Only: </label></td>
                                    <td><button type="button" id="btnOutCab1Weight" onclick='onClick_Cab1Weight()'>Get From Scale</button><label id="lblOutCab1Weight"></label></td>   
                                    <td><span id="undoOutCab1Weight" class="Mi4_undoIcon" onclick="onClick_undoCab1Weight()"></span></td>
                                    <td><button type="button" id="btnOutManualCab1Weight" onclick='onClick_setManualWeight(2)'>Set Manually</button></td>
                                    <td><button type="button" id="btnOutCalCab1" onclick='onClick_calcWeight(2)'>Calculate</button></td></tr>
                                <tr><td><label id="lblOutCab1wTrailerTextDialogBox">Cab 1 w/ Trailer: </label></td>
                                    <td><button type="button" id="btnOutCab1wTrailerWeight" onclick='onClick_Cab1wTrailerWeight()'>Get From Scale</button><label id="lblOutCab1wTrailerWeight"></label></td>   
                                    <td><span id="undoOutCab1wTrailerWeight" class="Mi4_undoIcon" onclick="onClick_undoCab1wTrailerWeight()"></span></td>
                                    <td><button type="button" id="btnOutManualCab1wTrailerWeight" onclick='onClick_setManualWeight(6)'>Set Manually</button></td>
                                    <td><button type="button" id="btnOutCalCab1wTrailer" onclick='onClick_calcWeight(7)'>Calculate</button></td></tr>
                               <tr><td><label id="lblOutGross">Cab 1, Trailer, & Product(s):</label><td><button type="button" id="btnOutGrossWeight" onclick='onClick_GrossWeight()'>Get From Scale</button>    
                                    <label id="lblOutGrossWeight"></label></td>
                                    <td><span id="undoOutGrossWeight" class="Mi4_undoIcon" onclick="onClick_undoGrossWeight()"></span></td>
                                    <td><button type="button" id="btnOutManualGrossWeight" onclick='onClick_setManualWeight(1)'>Set Manually</button></td></tr>
                                <tr><td><label id="lblOutCab2wTrailerTextDialogBox">Cab 2 w/ Trailer: </label></td>
                                    <td><button type="button" id="btnOutCab2wTrailerWeight" onclick='onClick_Cab2wTrailerWeight()'>Get From Scale</button><label id="lblOutCab2wTrailerWeight"></label></td>   
                                    <td><span id="undoOutCab2wTrailerWeight" class="Mi4_undoIcon" onclick="onClick_undoCab2wTrailerWeight()"></span></td>
                                    <td><button type="button" id="btnOutManualCab2wTrailerWeight" onclick='onClick_setManualWeight(4)'>Set Manually</button></td>
                                    <td><button type="button" id="btnOutCalCab2wTrailer" onclick='onClick_calcWeight(4)'>Calculate</button></td>
                            </table>
                                <%--trailer--%>
                            <table id="weightOptionsTrailer">
                    
                                <tr><td>
                                    <label id="lblHiddenlabel">Cab 1, Trailer, & Product(s):</label><td><button type="button" id="btnHidden1">Get From Scale</button>   
                                    <label id="lblHiddenlabel2"></label></td>
                                    <td><span id="lblHiddenUndo" class="Mi4_undoIcon"></span></td>
                                    <td><button type="button" id="btnHidden2">Set Manually</button>
                                    </td></tr>
                

                                <tr><td><label id="lblTrailerTextDialogBox">Trailer: </label></td>
                                    <td><button type="button" id="btnTrailerWeight" onclick='onClick_TrailerWeight()'>Get From Scale</button><label id="lblTrailerWeight"></label></td>  
                                    <td><span id="undoTrailerWeight" class="Mi4_undoIcon" onclick="onClick_undoTrailerWeight()"></span></td>
                                    <td><button type="button" id="btnManualTrailerWeight" onclick='onClick_setManualWeight(5)'>Set Manually</button></td>
                                    <td><button type="button" id="btnCalcTrailer" onclick='onClick_calcWeight(5)'>Calculate</button></td></tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
                               
            <label id="lblNoSamples"></label>
                <p> <span>
                        <input type='button' id="btnCalcNet" value='Calculate Net' onclick='onClick_calculateNetDialog();'>
                        <label id="lblNetWeight"></label>
                    </span>
                    <span>
                        <label id="lblSpecificGravity">Specific Gravity: </label>
                        <label id="lblSpecificGravityVal"></label>
                    </span>
                    <span>
                        <input type='button' id="btnCalcVol" value='Calculate Product Volume' onclick='onClick_calcVol();'>
                        <label id="lblVolVal"></label>
                    </span>
                </p>
        </div>

        </div>  
        <br />
        <div id="SendToAreaDetails"  class="detailBox">
            <h2>Send to: </h2>
            <input id='btnToWatingArea' type='button' value='Waiting' onclick='onClick_SendToWaitingArea();' class='ColumnContentExtend'/> 
            <input id='btnToYard' type='button' value='Yard' onclick='onClick_SendToYard();' class='ColumnContentExtend'/> 
             <p style="display:none; color: red; font-weight: bold;"id="msgSendTruck">Sending Truck...</p>
        </div>
        <br />
          <div id="FilesDetails"  class ="detailBox">
            <h2>Upload Files:</h2>
            <h3>BOL files: 
                <span>
                    <span id="dBOLcontainer" data-fileID=""><a id="alinkBOL"></a>
                    </span>
                    <span>
                        <span id='dDelBOL'><img src='Images/xclose.png' onclick='onclick_deleteBOL();return false;' height='16' width='16'/></span>
                        <span id='dUpBOL' class='uploadBOL'>
                            <img src='Images/triangleDown.png' onclick='onclick_addFile("#igUploadBOL_ibb_fp");return false;' height='16' width='16' />
                        </span>
                    </span>
                </span>
            </h3>
              <h3>COFA files: 
                <span>
                    <span id="dCOFAcontainer" data-fileID=""><a id="alinkCOFA"></a>
                    </span>
                    <span>
                        <span id='dDelCOFA'><img src='Images/xclose.png' onclick='onclick_deleteCOFA();return false;' height='16' width='16'/></span>
                        <span id='dUpCOFA' class='uploadBOL'>
                            <img src='Images/triangleDown.png' onclick='onclick_addFile("#igUploadCOFA_ibb_fp");return false;' height='16' width='16' />
                        </span>
                    </span>
                </span>
            </h3>
            <h3>Other files:</h3>
            <div class="ContentExtend"><table id="gridFiles" class="ContentExtend"></table></div>
        </div>
        <br />
           <p><button type="button" id="btnSaveMoreDetails" onclick='onClick_SaveDriverInfoAndClose();'>Save And Close</button></p>
           <p style="display:none; color: red; font-weight: bold;"id="saveMoreDriverInfoText">Driver Info Saved</p>
       <input style="display:none;" id='btnCloseMoreDetails' type='button' value='Close' onclick='onClick_CloseMoreDetails();'/> 
            
    </div>
        

    </asp:Content>