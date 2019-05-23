
<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="guardStation.aspx.cs" Inherits="TransportationProject.Scripts.guardStation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>
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

         <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>

         function onSuccess_getPODetailsFromMSID(value, ctx, methodName) {
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
         function onFail_getPODetailsFromMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getPODetailsFromMSID");
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
             PageMethods.getLogDataByMSID(MSIDofSelectedTruck, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSIDofSelectedTruck);
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
             $("#undoCheckOutLocationDialogBox").igDialog("close");
         }

         function onFail_updateLocationAndUndoCheckOut(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_updateLocationAndUndoCheckOut");
         }

         function onSuccess_checkIfTrailerDropped(hasBeenDropped, PO, methodName) {
             var Trailer = $("#grid").igGrid("getCellValue", PO, "TRAILER");
             var MSID = $("#grid").igGrid("getCellValue", PO, "MSID");
             if (hasBeenDropped == true) {
                 c = confirm("You are about to check out PO # " + PO + " with trailer # " + Trailer + ". Would you like to continue?");
                 if (c == true) {
                     $("#grid").data("data-MSID", MSID);
                     PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_CheckInCheckOutAndUndos, onFail_checkCurrentStatus, "Out");
                     //PageMethods.checkOut(MSID, onSuccess_checkOut, onFail_checkOut);
                 }
             }
             else {
                 c = confirm("Records show that PO # " + PO + " has a trailer (trailer # " + Trailer + ") that has not been dropped. Would you like to continue checking out?");
                 if (c == true) {
                     $("#grid").data("data-MSID", MSID);
                     PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_CheckInCheckOutAndUndos, onFail_checkCurrentStatus, "Out");
                     //PageMethods.checkOut(MSID, onSuccess_checkOut, onFail_checkOut);
                 }
             }
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
                     "isDROPTRAILER": isDropTrailer, "CARRIERINFO": value[i][20], "isOpenInCMS": isOpenInCMS, "LOADTYPE": value[i][22], "TRUCKTYPE": value[i][23],
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
                     "isDROPTRAILER": isDropTrailer, "CARRIERINFO": value[i][20], "isOpenInCMS": isOpenInCMS, "LOADTYPE": value[i][22], "TRUCKTYPE": value[i][23],
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

         function onSuccess_getStatusOptions(value, ctx, methodName) {
             GLOBAL_STATUS_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_STATUS_OPTIONS[i] = { "STATUS": value[i][0], "STATUSTEXT": value[i][1] };
             }
             PageMethods.getLocationOptions(onSuccess_getLocationOptions, onFail_getLocationOptions);
         }

         function onFail_getStatusOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getStatusOptions");
         }

         function onSuccess_getLocationOptions(value, ctx, methodName) {
             GLOBAL_LOCATION_OPTIONS = [];
             for (i = 0; i < value.length; i++) {
                 GLOBAL_LOCATION_OPTIONS[i] = { "LOCATION": value[i][0], "LOCATIONTEXT": value[i][1] };
             }
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridData, onFail_getGuardStationGridData);
         }

         function onFail_getLocationOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_getLocationOptions");
         }

         function onSuccess_launchAppAndUpdateWeight(weightValues, MSID, methodName) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights_RePop, onFail_getCurrentWeights);
         }
         function onFail_launchAppAndUpdateWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_launchAppAndUpdateWeight");
         }

         function onSuccess_checkAndUpdateWeights(weightValues, ctx, methodName) {
             renderWeightDialogBoxOptions(weightValues);
         }
         function onFail_checkAndUpdateWeights(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkAndUpdateWeights");
         }
         function onSuccess_checkIn(value, MSID, methodName) {
             PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);

         }
         function onFail_checkIn(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkIn");
         }
         function onSuccess_checkOut(value, ctx, methodName) {
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
             PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
         }
         function onFail_checkOut(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_checkOut");
         }
         function onSuccess_undoCheckIn(returnMessage, MSID, methodName) {
             if (!checkNullOrUndefined(returnMessage))
             {
                 if (returnMessage[0] == 'true') {
                     PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
                     PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
                 }
                 else {
                     alert(returnMessage[1]);
                 }
             }
             else{
                 alert("The application has encountered an error. Please refresh the page and try to undo check in again.");
             }
         }
         function onFail_undoCheckIn(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_undoCheckIn");
         }
         function onSuccess_undoCheckOut(returnMessage, MSID, methodName) {
             if (!checkNullOrUndefined(returnMessage)) {
                 if (returnMessage[0] == 'true') {
                     PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
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
                 renderWeightDialogBoxOptions(weightValues);
             }

         }
         function onFail_calculateWeight(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_calculateWeight");
         }

         function onSuccess_updateWeightManually(weightValues, weightData, methodName) {
             PageMethods.getGuardStationGridData(onSuccess_getGuardStationGridDataRebind, onFail_getGuardStationGridData);
             renderWeightDialogBoxOptions(weightValues);
         }
         function onFail_updateWeightManually(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx, onFail_updateWeightManually");
         }

         function onSuccess_updateRowData(value, ctx, methodName) {
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

         function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
             truckLog_OnSuccess_Render(returnValue, MSID);
         }

         function onFail_getLogDataByMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_getLogDataByMSID");
         }


         function onSuccess_checkIfManualEntryIsEnabled(value, ctx, methodName) {
             if (value) {
                 $("#btnManualGrossWeight").prop("disabled", false);
                 $("#btnManualCab1Weight").prop("disabled", false);
                 $("#btnManualCab2Weight").prop("disabled", false);
                 $("#btnManualCab2wTrailerWeight").prop("disabled", false);
                 $("#btnManualTrailerWeight").prop("disabled", false);
             }
             else {
                <%--disable --%>
                 $("#btnManualGrossWeight").prop("disabled", true);
                 $("#btnManualCab1Weight").prop("disabled", true);
                 $("#btnManualCab2Weight").prop("disabled", true);
                 $("#btnManualCab2wTrailerWeight").prop("disabled", true);
                 $("#btnManualTrailerWeight").prop("disabled", true);
             }
         }

         function onFail_checkIfManualEntryIsEnabled(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_checkIfManualEntryIsEnabled");
         }


         function onSuccess_getLogList(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     var POTrailerCombo = comboPOAndTrailer(value[i][1], value[i][2]);

                     GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailerCombo });
                 }
                 $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                 $("#cboxLogTruckList").igCombo("dataBind");
             }
         }
         function onFail_getLogList(value, ctx, methodName) {
             sendtoErrorPage("Error in guardStation.aspx onFail_getLogList");
         }
         function onSuccess_checkCurrentStatus_CheckInCheckOutAndUndos(currentStatus, actionAttempted, methodName) {
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
                 PageMethods.checkOut(MSID, onSuccess_checkOut, onFail_checkOut, MSID);
             }
             else if (currentStatus == "NOS" && actionAttempted == "In") {
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
         function onSuccess_checkCurrentStatus_OpenWeightDialog(currentStatus, ctx, methodName) {
             if (currentStatus == "NOS") {
                 $("#weightDialogBox").data("data-NOS", true);
                 <%--hide all buttons since weight cant be updated--%>
                 //console buttons
                 $("#btnGrossWeight").hide();
                 $("#btnCab1Weight").hide();
                 $("#btnCab2Weight").hide();
                 $("#btnCab2wTrailerWeight").hide();
                 $("#btnTrailerWeight").hide();

                 //undo buttons
                 $("#undoGrossWeight").hide();
                 $("#undoCab1Weight").hide();
                 $("#undoCab2Weight").hide();
                 $("#undoCab2wTrailerWeight").hide();
                 $("#undoTrailerWeight").hide();
                 $("#undoNetWeight").hide();
                 
                 //manual buttons
                 $("#btnManualGrossWeight").hide();
                 $("#btnManualCab1Weight").hide();
                 $("#btnManualCab2Weight").hide();
                 $("#btnManualCab2wTrailerWeight").hide();
                 $("#btnManualTrailerWeight").hide();

                 //calc buttons
                 $("#btnCalCab1").hide();
                 $("#btnCalCab2").hide();
                 $("#btnCalCab2wTrailer").hide();
                 $("#btnCalTrailer").hide();
                 $("#btnCalNet").hide();
                 alert("Truck is no longer on site and weights can not be updated.");
             }
             else {
                 $("#weightDialogBox").data("data-NOS", false);
             }
             $("#weightDialogBox").igDialog("open");
        }
        function onFail_checkCurrentStatus(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_checkCurrentStatus");
        }

        function onSuccess_updateDriverInfo(value, arrayDriverInfo, methodName) {
            var MSID = $("#detailsDialog").data("data-MSID");
            var index = searchDataSourceByMSID(MSID);

            GLOBAL_GRID_DATA[index].DRIVERNAME = arrayDriverInfo[0];
            GLOBAL_GRID_DATA[index].DRIVERPHONENUMBER = arrayDriverInfo[1];
            GLOBAL_GRID_DATA[index].CARRIERINFO = arrayDriverInfo[2];

            $("#saveDriverInfoText").css("display", "block");
            $("#saveDriverInfoText").fadeOut(3000);
        }
        function onFail_updateDriverInfo(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_updateDriverInfo");
        }

        function onSuccess_updateGSComment(value, GSComment, methodName) {
            var MSID = $("#detailsDialog").data("data-MSID");
            var index = searchDataSourceByMSID(MSID);

            GLOBAL_GRID_DATA[index].COMMENTS = GSComment;

            $("#saveGSComment").css("display", "block");
            $("#saveGSComment").fadeOut(3000);
        }
        function onFail_updateGSComment(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_updateGSComment");
        }
        function onSuccess_getCurrentWeights_RePop(weightValues, MSID, methodName) {
            renderWeightDialogBoxOptions(weightValues);
        }

        function onSuccess_getCurrentWeights(weightValues, MSID, methodName) {
            $("#weightDialogBox").data("data-MSID", MSID);

            renderWeightDialogBoxOptions(weightValues);
            var trailer = "";
            var index = searchDataSourceByMSID(MSID);
            var isDropTrailer = GLOBAL_GRID_DATA[index].isDROPTRAILER;
            $("#weightDialogBox").data("data-isDropTrailer", isDropTrailer);

            if (GLOBAL_GRID_DATA[index].TRAILER != null) {
                trailer = GLOBAL_GRID_DATA[index].TRAILER;
            }

            $("#lblTitleWeightDialogBox").html("Weights associated with PO# " + GLOBAL_GRID_DATA[index].PO + " Trailer# " + trailer);

            PageMethods.getNetWeightAndSpecificGravity(MSID, onSuccess_getNetWeightAndSpecificGravity, onFail_getNetWeightAndSpecificGravity, weightValues[5]);
        }

        function onFail_getCurrentWeights(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_getCurrentWeights");
        }

        function onSuccess_getNetWeightAndSpecificGravity(specGrav, netWeight, methodName) {
            var MSID = $("#weightDialogBox").data("data-MSID");
            if (netWeight > 0 && specGrav != 0) {
                $("#lblProductNetVal").html(netWeight);
                $("#lblSpecificGravityVal").html(specGrav.toFixed(4));
                $("#SampleWeights").show();
                $("#lblNoSamples").hide();

                var isNOS = $("#weightDialogBox").data("data-NOS");
                if (isNOS == true) {
                    onClick_calcVol();
                    $("#btnVolCal").hide();
                }
                else {
                    $("#btnVolCal").show();
                }
            }
            else {
                $("#SampleWeights").hide();
                $("#lblNoSamples").show();
                if (netWeight == 0 && specGrav == 0) {
                    $("#lblNoSamples").html("Product weight cannot be calculated. A sample with specific gravity has not been approved and the net weight has not been calculated for this order.")
                }
                else if (netWeight == 0) {
                    $("#lblNoSamples").html("Product weight cannot be calculated. Net weight has not been calculated for this order.")
                }
                else if (specGrav == 0) {
                    $("#lblNoSamples").html("Product weight cannot be calculated. A sample with specific gravity has not been approved yet for this order.")
                }
            }
        }

        function onSuccess_getNetWeightAndSpecificGravity_NOS(specGrav, netWeight, methodName) {
            var MSID = $("#weightDialogBox").data("data-MSID");
            if (netWeight != 0 && specGrav != 0) {
                $("#lblProductNetVal").html(netWeight);
                $("#lblSpecificGravityVal").html(specGrav.toFixed(4));
                $("#SampleWeights").show();
                $("#lblNoSamples").hide();
            }
            else {
                $("#SampleWeights").hide();
                $("#lblNoSamples").show();
                if (netWeight == 0 && specGrav == 0) {
                    $("#lblNoSamples").html("Product weight cannot be calculated. A sample with specific gravity has not been approved and the net weight has not been calculated for this order.")
                }
                else if (netWeight == 0) {
                    $("#lblNoSamples").html("Product weight cannot be calculated. Net weight has not been calculated for this order.")
                }
                else if (specGrav == 0) {
                    $("#lblNoSamples").html("Product weight cannot be calculated. A sample with specific gravity has not been approved yet for this order.")
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
                PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_CheckInCheckOutAndUndos, onFail_checkCurrentStatus, "uOut");

            }

        }
        function onFail_getCurrentLocationAndStatusB4Undo(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_getCurrentLocationAndStatusB4Undo");
        }

        function onSuccess_addFileDBEntry(value, ctx, methodName) {
            var msid = $('#detailsDialog').data("data-MSID");
            PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
        }

        function onFail_addFileDBEntry(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_addFileDBEntry");
        }
        function onSuccess_getFileUploadsFromMSID(value, ctx, methodName) {
            var msid = ctx;
            <%--clear data from controls --%>
            $('#alinkBOL').text("");
            $('#dUpBOL').show();
            $('#dDelBOL').hide();

            if (value.length > 0) {
                var gridData = [];

                var rowCount = 0;
                for (var i = 0; i < value.length; i++) {
                    if (1 === value[i][2]) { <%-- if filetype is BOL -> BOL ===1 (set to filetype in db if changed)--%>
                        $('#alinkBOL').text(value[i][6]);
                        $("#alinkBOL").attr("href", value[i][4] + "/" + value[i][5])
                        $('#dBOLcontainer').data("data-fileID", value[i][0]);
                        $('#dUpBOL').hide();
                        $('#dDelBOL').show();
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

        function onFail_getFileUploadsFromMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_getFileUploadsFromMSID");
        }

        function onSuccess_getCOFAFileUploadsFromMSID(value, ctx, methodName) {
            var gridData = [];
            for (i = 0; i < value.length; i++) {
                value[i] = {
                    "FID": value[i][0], "MSID": value[i][1], "FILETYPEID": value[i][2], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5],
                    "FNAMEOLD": value[i][6], "CMSPRODUCTID": value[i][7], "CMSPRODUCTNAME": value[i][8]
                };
            }
            $("#gridCOFAFiles").igGrid("option", "dataSource", gridData);
            $("#gridCOFAFiles").igGrid("dataBind");
            $("#detailsDialog").data("ID", ctx).igDialog("open");

        }

        function onFail_getCOFAFileUploadsFromMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_getCOFAFileUploadsFromMSID");
        }

        function onSuccess_updateFileUploadData(value, ctx, methodName) {
            <%--Success do nothing --%>
            $("#gridFiles").igGrid("commit");
        }

        function onFail_updateFileUploadData(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx, onFail_updateFileUploadData");
        }


        function onSuccess_processFileAndData(value, ctx, methodName) {
            if (ctx) {
                if ("BOL" === ctx[1]) {
                      <%--Add entry into DB --%>
                    PageMethods.addFileDBEntry(ctx[2], "BOL", ctx[0], value[1], value[0], "BOL", onSuccess_addFileDBEntry, onFail_addFileDBEntry, ctx)

                }
                else if ("OTHER" === ctx[1]) {
                      <%--Add OTHER filetype entry into db only happens on add row finished because need to get Detail column--%>
                    <%--add attributes related to grid for use when adding new row --%>
                      $("#gridFiles").data("data-FPath", value[0]);
                      $("#gridFiles").data("data-FNameNew", value[1]);
                      $("#gridFiles").data("data-FNameOld", ctx[0]);

                    <%--change text of add new row's filename column to uploaded file's original name --%>
                      $("#detailsDialog tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(ctx[0]);
                  }
          }
      }

      function onFail_processFileAndData(value, ctx, methodName) {
          sendtoErrorPage("Error in guardStation.aspx, onFail_processFileAndData");
      }

      function onSuccess_deleteFileDBEntry(value, ctx, methodName) {

          var msid = $('#detailsDialog').data("data-MSID");
          PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
      }

      function onFail_deleteFileDBEntry(value, ctx, methodName) {
          sendtoErrorPage("Error in guardStation.aspx, onFail_deleteFileDBEntry");
      }

      function onSuccess_verifyAndMove(returnString, ctx, methodName) {
          if (returnString == 'success') {
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
         function openProductDetailDialog(MSID, rowID) {
             var PO = $("#grid").igGrid("getCellValue", rowID, "PO");
             var trailer = $("#grid").igGrid("getCellValue", rowID, "TRAILER");
             var POTrailer = comboPOAndTrailer(PO, trailer);
             PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
             if (POTrailer) {
                 $("#dvProductDetailsPONUM").text(POTrailer);
             }
         }

         function clearGridFilters(evt, ui) {
             $("#grid").igGridFiltering("filter", []);
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
             var netProduct = $("#lblProductNetVal").html();
             var specificGravity = $("#lblSpecificGravityVal").html();
             var vol = netProduct / (specificGravity * 8.32823); <%--8.32823 constant--%>
             $("#lblVolVal").html(vol);
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
                     if (currentCab2WTrailer > 0 && currentTrailer > 0) {
                         PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     }
                     else {
                         alert("There is not enough weight data to calculated the weight of cab in at this time. Please try again when you have the cab with trailer and trailer weights.")
                     }
                     break;
                 case 3:<%--cab2--%>
                     if (isDropTrailer == true) {
                         if (currentCab2WTrailer > 0 && currentTrailer > 0) {
                             PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                         }
                         else {
                             alert("There is not enough weight data to calculated the weight of cab out at this time. Please try again when you have the cab with trailer and trailer weights.")
                         }
                     }
                     else {
                         alert("This order is not a drop trailer and this weight can not be calculated");
                     }
                     break;
                 case 4:<%--cab2WTrailer--%>
                     if (currentCab2 > 0 && currentTrailer > 0) {
                         PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     }
                     else {
                         alert("There is not enough weight data to calculated the weight of cab out at this time. Please try again when you have the cab with trailer and trailer weights.")
                     }

                     break;
                 case 5:<%--trailer--%>
                     if (currentCab2 > 0 && currentCab2WTrailer > 0) {
                         PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     }
                     else {
                         alert("There is not enough weight data to calculated the weight of cab out at this time. Please try again when you have the cab with trailer and trailer weights.")
                     }

                     break;
                 case 6:<%--net--%>
                     PageMethods.calculateWeight(MSID, weightType, onSuccess_calculateWeight, onFail_calculateWeight);
                     break;

             }
         }

         function renderWeightDialogBoxOptions(weightValues) {
             var MSID = $("#weightDialogBox").data("data-MSID");
             var index = searchDataSourceByMSID(MSID);
             var isDropTrailer = GLOBAL_GRID_DATA[index].isDROPTRAILER;
             $("#weightDialogBox").data("data-isDropTrailer", isDropTrailer);

             var gross = weightValues[0];
             var cab1Solo = weightValues[1];
             var cab2Solo = weightValues[2];
             var cab2WithTrailer = weightValues[3];
             var trailer = weightValues[4];
             var net = weightValues[5];

             var grossObtainMethod = weightValues[6];
             var cab1ObtainMethod = weightValues[7];
             var cab2ObtainMethod = weightValues[8];
             var cab2WithTrailerObtainMethod = weightValues[9];
             var trailerObtainMethod = weightValues[10];


             if (gross > 0.0) {//Gross
                 $("#btnGrossWeight").hide();
                 $("#lblGrossWeight").html(weightValues[0]);
                 $("#lblGrossWeight").show();
                 $("#undoGrossWeight").show();
                 $("#btnManualGrossWeight").hide();
                 if (isDropTrailer == "Yes") {
                     switch (grossObtainMethod) {
                         case 1:
                             $("#lblGrossTextDialogBox").html("(Gross) Cab In with Trailer & Products - From Scale: ");
                             break;
                         case 2:
                             $("#lblGrossTextDialogBox").html("(Gross) Cab In with Trailer & Products - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblGrossTextDialogBox").html("(Gross) Cab In with Trailer & Products - Calculated: ");
                             break;
                     }
                     $("#lblGrossTextDialogBox").show();
                 }
                 else {
                     switch (grossObtainMethod) {
                         case 1:
                             $("#lblGrossTextDialogBox").html("(Gross) Cab with Trailer & Products - From Scale: ");
                             break;
                         case 2:
                             $("#lblGrossTextDialogBox").html("(Gross) Cab with Trailer & Products - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblGrossTextDialogBox").html("(Gross) Cab with Trailer & Products - Calculated: ");
                             break;
                     }
                     $("#lblGrossTextDialogBox").show();
                 }

             }
             else {
                 $("#btnGrossWeight").show();
                 $("#undoGrossWeight").hide();
                 $("#lblGrossWeight").html("");
                 $("#btnManualGrossWeight").show();
                 if (isDropTrailer == "Yes") {
                     $("#lblGrossTextDialogBox").html("(Gross) Cab In with Trailer & Products: ");
                     $("#lblGrossTextDialogBox").show();
                 }
                 else {
                     $("#lblGrossTextDialogBox").html("(Gross) Cab with Trailer & Products: ");
                     $("#lblGrossTextDialogBox").show();
                 }
             }

             if (cab1Solo > 0.0) {<%--cab 1--%>
                 $("#btnCab1Weight").hide();
                 $("#lblCab1Weight").html(weightValues[1]);
                 $("#lblCab1Weight").show();
                 $("#undoCab1Weight").show();
                 $("#btnManualCab1Weight").hide();
                 $("#btnCalCab1").hide();

                 if (isDropTrailer == "Yes") {
                     switch (cab1ObtainMethod) {
                         case 1:
                             $("#lblCab1TextDialogBox").html("Cab In Only - From Scale: ");
                             break;
                         case 2:
                             $("#lblCab1TextDialogBox").html("Cab In Only - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblCab1TextDialogBox").html("Cab In Only - Calculated: ");
                             break;
                     }
                 }
                 else {
                     switch (cab1ObtainMethod) {
                         case 1:
                             $("#lblCab1TextDialogBox").html("Cab Only - From Scale: ");
                             break;
                         case 2:
                             $("#lblCab1TextDialogBox").html("Cab Only - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblCab1TextDialogBox").html("Cab Only - Calculated: ");
                             break;
                     }
                     $("#btnCab1Weight").text("Get Cab Weight");
                 }

             }
             else {
                 $("#btnCab1Weight").show();
                 $("#undoCab1Weight").hide();
                 $("#lblCab1Weight").html("");
                 $("#btnManualCab1Weight").show();
                 $("#btnCalCab1").show();

                 if (isDropTrailer == "Yes") {
                     $("#lblCab1TextDialogBox").html("Cab In Only: ");
                     $("#btnCab1Weight").text("Get Cab In Weight");
                     $("#btnCalCab1").html("Calculate Cab In ");
                 }
                 else {
                     $("#lblCab1TextDialogBox").html("Cab Only: ");
                     $("#btnCab1Weight").text("Get Cab Weight");
                     $("#btnCalCab1").html("Calculate Cab");
                 }

                 if ((trailer > 0 && cab2WithTrailer > 0)) {
                     $("#btnCalCab1").prop("disabled", false);
                 }
                 else {
                     $("#btnCalCab1").prop("disabled", true);
                 }



             }

             if (cab2Solo > 0.0) {<%--cab 2--%>
                 $("#btnCab2Weight").hide();
                 $("#lblCab2Weight").html(weightValues[2]);
                 $("#lblCab2Weight").show();
                 $("#undoCab2Weight").show();
                 $("#btnManualCab2Weight").hide();
                 $("#btnCalCab2").hide();
                 if (isDropTrailer == "Yes") {
                     switch (cab2ObtainMethod) {
                         case 1:
                             $("#lblCab2TextDialogBox").html("Cab Out Only - From Scale: ");
                             break;
                         case 2:
                             $("#lblCab2TextDialogBox").html("Cab Out Only - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblCab2TextDialogBox").html("Cab Out Only - Calculated: ");
                             break;
                     }
                 }
                 else {
                     $("#lblCab2TextDialogBox").hide();
                     $("#btnCab2Weight").hide();
                     $("#lblCab2Weight").hide();
                     $("#undoCab2Weight").hide();
                     $("#btnManualCab2Weight").hide();
                 }
             }
             else {
                 if (isDropTrailer == "Yes") {
                     $("#lblCab2TextDialogBox").html("Cab Out Only: ");
                     $("#lblCab2TextDialogBox").show();
                     $("#undoCab2Weight").hide();
                     $("#btnCalCab2").show();
                     $("#btnCab2Weight").show();
                     $("#lblCab2Weight").html("");
                     $("#btnManualCab2Weight").show();

                     if (cab2WithTrailer > 0 && trailer > 0) {
                         $("#btnCalCab2").prop("disabled", false);
                     }
                     else {
                         $("#btnCalCab2").prop("disabled", true);
                     }
                 }
                 else {
                     $("#lblCab2TextDialogBox").hide();
                     $("#btnCab2Weight").hide();
                     $("#lblCab2Weight").hide();
                     $("#undoCab2Weight").hide();
                     $("#btnManualCab2Weight").hide();
                     $("#btnCalCab2").hide();
                 }

             }

             if (cab2WithTrailer > 0.0) {//Cab 2 w/ MT trailer
                 $("#btnCab2wTrailerWeight").hide();
                 $("#lblCab2wTrailerWeight").html(weightValues[3]);
                 $("#lblCab2wTrailerWeight").show();
                 $("#undoCab2wTrailerWeight").show();
                 $("#btnManualCab2wTrailerWeight").hide();
                 $("#btnCalCab2wTrailer").hide();
                 if (isDropTrailer == "Yes") {
                     switch (cab2WithTrailerObtainMethod) {
                         case 1:
                             $("#lblCab2wTrailerTextDialogBox").html("Cab Out with Trailer - From Scale: ");
                             break;
                         case 2:
                             $("#lblCab2wTrailerTextDialogBox").html("Cab Out with Trailer - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblCab2wTrailerTextDialogBox").html("Cab Out with Trailer - Calculated: ");
                             break;
                     }
                     $("#btnCab2wTrailerWeight").html("Get Cab Out with Trailer Weight");
                 }
                 else {
                     switch (cab2WithTrailerObtainMethod) {
                         case 1:
                             $("#lblCab2wTrailerTextDialogBox").html("Cab with Trailer - From Scale: ");
                             break;
                         case 2:
                             $("#lblCab2wTrailerTextDialogBox").html("Cab with Trailer - Manually Entered: ");
                             break;
                         case 3:
                             $("#lblCab2wTrailerTextDialogBox").html("Cab with Trailer - Calculated: ");
                             break;
                     }
                     $("#btnCab2wTrailerWeight").html("Get Cab with Trailer Weight");
                     $("#lblCab2wTrailerTextDialogBox").show();
                 }
             }
             else {
                 $("#btnCab2wTrailerWeight").show();
                 $("#undoCab2wTrailerWeight").hide();
                 $("#lblCab2wTrailerWeight").html("");
                 $("#btnManualCab2wTrailerWeight").show();
                 $("#btnCalCab2wTrailer").show();
                 if (isDropTrailer == "Yes") {
                     $("#lblCab2wTrailerTextDialogBox").html("Cab Out w/ Trailer: ");
                     $("#btnCab2wTrailerWeight").html("Get Cab Out with Trailer Weight");
                     $("#btnCalCab2wTrailer").html("Calculate Cab Out w/ Trailer");

                     if (cab2Solo > 0 && trailer > 0) {
                         $("#btnCalCab2wTrailer").prop("disabled", false);
                     }
                     else {
                         $("#btnCalCab2wTrailer").prop("disabled", true);
                     }



                 }
                 else {
                     $("#lblCab2wTrailerTextDialogBox").html("Cab w/ Trailer: ");
                     $("#btnCab2wTrailerWeight").html("Get Cab with Trailer Weight");
                     $("#btnCalCab2wTrailer").html("Calculate Cab w/ Trailer");

                     if (cab1Solo > 0 && trailer > 0) {
                         $("#btnCalCab2wTrailer").prop("disabled", false);
                     }
                     else {
                         $("#btnCalCab2wTrailer").prop("disabled", true);
                     }
                 }



             }

             if (trailer > 0.0) {<%--Trailer--%>
                 $("#btnTrailerWeight").hide();
                 $("#lblTrailerWeight").html(weightValues[4]);
                 $("#lblTrailerWeight").show();
                 $("#undoTrailerWeight").show();
                 $("#btnManualTrailerWeight").hide();
                 $("#btnCalTrailer").hide();
                 if (isDropTrailer == "Yes") {
                     switch (trailerObtainMethod) {
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
                 else {
                     switch (trailerObtainMethod) {
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
                 $("#btnTrailerWeight").show();
                 $("#undoTrailerWeight").hide();
                 $("#lblTrailerWeight").html("");
                 $("#btnManualTrailerWeight").show();
                 $("#btnCalTrailer").show();
                 $("#btnCalTrailer").html("Calculate Trailer");

                 if (isDropTrailer == "Yes") {
                     $("#lblTrailerTextDialogBox").html("Trailer Only: ");

                     if (cab2Solo > 0 && cab2WithTrailer > 0) {
                         $("#btnCalTrailer").prop("disabled", false);
                     }
                     else {
                         $("#btnCalTrailer").prop("disabled", true);
                     }
                 }
                 else {
                     $("#lblTrailerTextDialogBox").html("Trailer Only: ");

                     if (cab1Solo > 0 && cab2WithTrailer > 0) {
                         $("#btnCalTrailer").prop("disabled", false);
                     }
                     else {
                         $("#btnCalTrailer").prop("disabled", true);
                     }
                 }
             }

             if (net > 0.0) { <%--Net--%>
                 $("#lblNetWeight").html(weightValues[5]);
                 $("#lblNetWeight").show();
                 $("#btnCalNet").hide();
                 $("#lblNetTextDialogBox").html("Net Weight - Calculated: ");
                 $("#undoNetWeight").show();
                 var MSID = $("#weightDialogBox").data("data-MSID");
                 PageMethods.getNetWeightAndSpecificGravity(MSID, onSuccess_getNetWeightAndSpecificGravity, onFail_getNetWeightAndSpecificGravity, weightValues[5]);
             }
             else {
                 $("#undoNetWeight").hide();
                 $("#lblNetWeight").html("");
                 $("#btnCalNet").show();
                 $("#lblNetTextDialogBox").html("Net Weight - Calculated: ");
                 if (isDropTrailer == "Yes") {
                     if ((gross > 0 && cab2WithTrailer > 0) || (cab2Solo > 0 && trailer > 0 && gross > 0)) {
                         $("#btnCalNet").prop("disabled", false);
                     }
                     else {
                         $("#btnCalNet").prop("disabled", true);
                     }
                 }
                 else {
                     if ((gross > 0 && cab2WithTrailer > 0) || (cab1Solo > 0 && trailer > 0 && gross > 0)) {
                         $("#btnCalNet").prop("disabled", false);
                     }
                     else {
                         $("#btnCalNet").prop("disabled", true);
                     }
                     $("#lblNetTextDialogBox").html("Net Weight - Calculated: ");
                 }
             }
             PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_OpenWeightDialog, onFail_checkCurrentStatus, weightValues[5]);
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

         //function onClick_GetWeight(MSID, isWeighIn) {
         //    $("#grid").data("data-isWeighIn", isWeighIn);
         //    PageMethods.checkIfWeightTaken(MSID, isWeighIn, onSuccess_checkIfWeightTaken, onFail_checkIfWeightTaken, MSID);
         //}

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
         function onClick_CheckOut(MSID, PO) {
             var Trailer = $("#grid").igGrid("getCellValue", PO, "TRAILER");
             var c; 
             var docVeri = $("#grid").igGrid("getCellValue", PO, "DOCVERI");
             var isDropTrailer = $("#grid").igGrid("getCellValue", PO, "isDROPTRAILER");
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
                         PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_CheckInCheckOutAndUndos, onFail_checkCurrentStatus, "Out");
                     }
                 }
                 else {
                     PageMethods.checkIfTrailerDropped(MSID, onSuccess_checkIfTrailerDropped, onFail_checkIfTrailerDropped, PO);
                 }

             }
             else {
                 alert("Documents must be verified before check out.");
             }
         }
         function onClick_CheckIn(MSID) {
             $("#grid").data("data-MSID", MSID);
             PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_CheckInCheckOutAndUndos, onFail_checkCurrentStatus, "In");
             //PageMethods.checkIn(MSID, onSuccess_checkIn, onFail_checkIn, MSID);
         }

         function undoCheckOut(MSID) {
             $("#undoCheckOutLocationDialogBox").data("data-MSID", MSID);
             PageMethods.getUndoLocationOptions(MSID, onSuccess_getUndoLocationOptions, onFail_getUndoLocationOptions, MSID);
         }
         function undoCheckIn(MSID) {
             $("#grid").data("data-MSID", MSID);
             PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_CheckInCheckOutAndUndos, onFail_checkCurrentStatus, "uIn");
         }

         function onClick_SetVerify(MSID) {
             var PO = GLOBAL_GRID_DATA[findDatasetFromMSID(MSID)].PO;
             var status = $("#grid").igGrid("getCellValue", PO, "STATUS");
             if (status != 'NOS') {
                 PageMethods.setVerify(MSID, onSuccess_setVerify, onFail_setVerify);
             }
             else {
                 alert("This truck has been released and its entry can no longer be edited.");
             }
         }
         function undoVerify(MSID) {
             var PO = GLOBAL_GRID_DATA[findDatasetFromMSID(MSID)].PO;
             var status = $("#grid").igGrid("getCellValue", PO, "STATUS");
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
             PageMethods.getCurrentWeights(MSID, onSuccess_getCurrentWeights, onFail_getCurrentWeights, MSID);
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

         function onClick_TrailerWeight() {
             var MSID = $("#weightDialogBox").data("data-MSID");
             PageMethods.launchAppAndUpdateWeight(MSID, "T", onSuccess_launchAppAndUpdateWeight, onFail_launchAppAndUpdateWeight, MSID);
         }

         function validatePhoneNumber(pNumber) {
             var reg = /^[2-9]\d{2}[2-9]\d{2}\d{4}$/;
             return reg.test(pNumber);
         } 

         function onClick_SendToYard(MSID) {
             PageMethods.verifyAndMove(MSID, "yard", onSuccess_verifyAndMove, onFail_verifyAndMove, "yard");
         }
         function onClick_SendToWaitingArea(MSID) {
             PageMethods.verifyAndMove(MSID, "wait", onSuccess_verifyAndMove, onFail_verifyAndMove, "wait");
         }

         function onClick_OpenDetailsDialogBox(MSID) {
             $("#detailsDialog").data("data-MSID", MSID);
             $("#dwFileUpload span.anr_t:contains('Add new row')").text("Add new file"); <%-- change label on grid --%>
             $('#dwFileUpload td[title="Click to start adding new row"]').attr('title', "Click to start adding new file");
             PageMethods.getFileUploadsFromMSID(MSID, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, MSID);
             

             var index;
             var dName = "";
             var dNumber = "";
             var cInfo = "";
             var trailerNum;
             var GSComment = "";
             var headerString;
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

             if (checkNullOrUndefined(GLOBAL_GRID_DATA[index].CARRIERINFO) == false) {
                 cInfo = GLOBAL_GRID_DATA[index].CARRIERINFO;
             }
             $("#lblCarrierInfo").html("");
             $("#lblCarrierInfo").hide();
             $("#txtAreaCarrierInfo").val(cInfo);
             $("#txtAreaCarrierInfo").show();

             $("#btnSaveDriverInfo").show();
             $("#btnCancelDriverInfo").show();

             if (checkNullOrUndefined(GLOBAL_GRID_DATA[index].COMMENTS) == false) {
                 GSComment = GLOBAL_GRID_DATA[index].COMMENTS;
             }
             $("#txtAreaGSComment").val(GSComment);
             

             $("#detailsDialog").igDialog("open");


         }
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
         function onClick_SaveGSComment() {
             var MSID = $("#detailsDialog").data("data-MSID");
             var GSComment = $("#txtAreaGSComment").val();
             PageMethods.updateGSComment(MSID, GSComment, onSuccess_updateGSComment, onFail_updateGSComment, GSComment);
         }

         function onClick_SaveDriverInfo() {
             var MSID = $("#detailsDialog").data("data-MSID");
             var driverName = $("#txtDriverName").val();
             var driverPhoneNumber = $("#txtDriverPhone").val();
             var carrierInfo = $("#txtAreaCarrierInfo").val();

             var arrayDriverInfo = [driverName, driverPhoneNumber, carrierInfo];

             var isValidPhoneNumber;

             if (checkNullOrUndefined(driverPhoneNumber)) {
                 isValidPhoneNumber = true;
             }
             else {
                 isValidPhoneNumber = validatePhoneNumber(driverPhoneNumber);
             }

             if (isValidPhoneNumber == true) {
                 PageMethods.updateDriverInfo(MSID, driverName, driverPhoneNumber, carrierInfo, onSuccess_updateDriverInfo, onFail_updateDriverInfo, arrayDriverInfo);
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
                 var msid = $('#detailsDialog').data("data-MSID");
                 PageMethods.deleteFileDBEntry(fid, "OTHER", msid, onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, "OTHER");
             }
         }
         function onclick_deleteBOL() {
             r = confirm("Continue removing the BOL from the truck data? This cannot be undone.")
             if (r) {
                 var fid = $('#dBOLcontainer').data("data-fileID");
                 var msid = $('#detailsDialog').data("data-MSID");
                 PageMethods.deleteFileDBEntry(fid, "BOL", msid, onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, "BOL");
             }
         }
         function onclick_deleteCOFA() {
             r = confirm("Continue removing the COFA from the truck data? This cannot be undone.")
             if (r) {
                 var fid = $('#dCOFAcontainer').data("data-fileID");
                 var msid = $('#detailsDialog').data("data-MSID");
                 PageMethods.deleteFileDBEntry(fid, "COFA", msid, onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, "COFA");
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
                 primaryKey: "PO",
                 autofitLastColumn: true,
                 columns:
                     [

                         { headerText: "", key: "BoolIsOpenInCMS", datatype: "boolean", width: "0px", hidden: true },
                         { headerText: "", key: "MSID", dataType: "number", width: "0px" },
                         { headerText: "", key: "MSIDTEXT", dataType: "string", width: "0px" },
                         { headerText: "", key: "PO", dataType: "number", width: "0px" },
                         {
                             headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED})}}" +
                              "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}", width: "60px"
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
                                    "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialog(${MSID}, ${PO}); return false;'></div>{{/if}}"
                        },
                         { headerText: "Drop Trailer", key: "isDROPTRAILER", dataType: "string", width: "70px" },
                         { headerText: "ETA", key: "ETA", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "120px" },
                         { headerText: "Load", key: "LOADTYPE", dataType: "string", width: "50px" },
                         { headerText: "Truck Type", key: "TRUCKTYPE", dataType: "string", width: "45px" },
                         { headerText: "Location", key: "LOCATION", dataType: "string", formatter: formatLocationCombo, width: "75px" },
                         { headerText: "Status", key: "STATUS", dataType: "string", formatter: formatStatusCombo, width: "100px" },
                         { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "90px" },
                         { headerText: "Cab In #", key: "CAB1NUM", dataType: "string", width: "0px" },
                         { headerText: "Cab Out #", key: "CAB2NUM", dataType: "string", width: "0px" },
                         {
                             headerText: "Check In", key: "CHECKIN", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px",
                             template: "{{if(checkNullOrUndefined(${CHECKIN})) === true}} <div class ='ColumnContentExtend'> <input id='btnCheckIn' type='button' value='Check In' onclick='onClick_CheckIn(${MSID});' class='ColumnContentExtend'/></div>" + 
                                        "{{elseif (checkNullOrUndefined(${CHECKIN})) === false && ${LOCATION} === 'GS'  && (hasBeenGoneForOverAnHour(${CHECKIN})) === false }} <div class ='ColumnContentExtend'>${CHECKIN} <span class='Mi4_undoIcon' onclick='undoCheckIn(${MSID})'></span> </div>" +
                                        "{{else}} <div class ='ColumnContentExtend'>${CHECKIN}</div>{{/if}}"
                         },
                         {
                             headerText: "Check Out", key: "CHECKOUT", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px",
                             template: "{{if(checkNullOrUndefined(${CHECKOUT})) === true && (checkNullOrUndefined(${CHECKIN})) === false}}<div class ='ColumnContentExtend'><input id='btnCheckOut' type='button' value='Check Out' onclick='onClick_CheckOut(${MSID}, ${PO});' class='ColumnContentExtend'/></div>" +
                                        "{{elseif (checkNullOrUndefined(${CHECKIN})) === false && (checkNullOrUndefined(${CHECKOUT})) === false && (hasBeenGoneForOverAnHour(${CHECKOUT})) === false}}<div class ='ColumnContentExtend'>${CHECKOUT}<span class='Mi4_undoIcon' onclick='undoCheckOut(${MSID})'></span></div>" +
                                        "{{elseif (checkNullOrUndefined(${CHECKIN})) === false && (checkNullOrUndefined(${CHECKOUT})) === false && (hasBeenGoneForOverAnHour(${CHECKOUT})) === true}}<div class ='ColumnContentExtend'>${CHECKOUT}</div>" + "{{else}}<div> </div>{{/if}}"
                         },
                         {
                             headerText: "Weights", key: "WEIGHTS", dataType: "number", width: "65px",
                             template: "{{if (checkNullOrUndefined(${CHECKIN}) == true)}} <div> </div> " +
                                       "{{else}} " + "<div class ='ColumnContentExtend'> <input id='btnWeighs' type='button' value='Weights' onclick='onClick_getWeights(${MSID});' class='ColumnContentExtend'> </div>{{/if}}"
                         },
                         {
                             headerText: "Docs Verified", key: "DOCVERI", dataType: "string", width: "60px", template: "{{if (checkNullOrUndefined(${DOCVERI})) == true && (checkNullOrUndefined(${CHECKIN}) == false) && (checkNullOrUndefined(${CHECKOUT}) == true)}} <div class ='ColumnContentExtend'> <input id='btnVerify' type='button' value='Verified' onclick='onClick_SetVerify(${MSID});' class='ColumnContentExtend'/> </div> " +
                                 "{{elseif (checkNullOrUndefined(${DOCVERI})) == false}}<div class ='ColumnContentExtend'><img src='Images/CheckMark.gif' height='16' width='16'/> <span class='Mi4_undoIcon' onclick='undoVerify(${MSID})'> </span> </div> {{/if}}"
                         },
                         {
                             headerText: "Send to...", key: "TOWAITINGAREA", dataType: "string", width: "80px",
                             template: "{{if (${LOCATION} == 'GS') && (${isDROPTRAILER} == 'No')}} <div class ='ColumnContentExtend'> <input id='btnToWatingArea' type='button' value='To Waiting' onclick='onClick_SendToWaitingArea(${MSID});' class='ColumnContentExtend'/> </div>  " +
                                 "{{elseif (${LOCATION} == 'GS') && (${isDROPTRAILER} == 'Yes')}} <div class ='ColumnContentExtend'> <input id='btnToYard' type='button' value='To Yard' onclick='onClick_SendToYard(${MSID});' class='ColumnContentExtend'/> </div> {{else}}<div></div>{{/if}}"
                         },
                         {
                             headerText: "Additional Details", key: "DRIVERINFO", dataType: "string", width: "55px", template: "{{if (checkNullOrUndefined(${CHECKIN}) == false)}} <div class ='ColumnContentExtend'><div class=\"tooltip\"> <input id='btnDriverInfo' type='button' value='Details' onclick='onClick_OpenDetailsDialogBox(${MSID});' class='ColumnContentExtend'/><span class=\"tooltiptext\">Driver Info, Files, & GS Comments</span><\div></div> {{/if}}"
                         },
                         <%--{ headerText: "Blanket Release #", key: "BLANKETPORELEASENUMBER", dataType: "number", width: "100px" },   // TODO: Implemented as needed--%>
                         { headerText: "Comments (max. 250)", key: "COMMENTS", dataType: "string", width: "0px" }

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

                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              $("#grid").data("data-MSID", row.MSID);
                              PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                          },
                          editRowEnding: function (evt, ui) {
                              var origEvent = evt.originalEvent;
                              if (typeof origEvent === "undefined") {
                                  ui.keepEditing = true;
                                  return false;
                              }
                              if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                  var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                  PageMethods.updateRowData(row.MSID, ui.values.TRAILER, null, null, null <%--ui.values.CAB1NUM, ui.values.CAB2NUM, ui.values.BLANKETPORELEASENUMBER, ui.values.COMMENTS,--%>, onSuccess_updateRowData, onFail_updateRowData);
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
                                 var msid = $("#detailsDialog").data("data-MSID");
                                 var desc = ui.values.DESC;

                                 PageMethods.addFileDBEntry(msid, "OTHER", fnameOld, fnameNew, fpath, desc, onSuccess_addFileDBEntry, onFail_addFileDBEntry);


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
                                     if ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) {
                                         var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                         PageMethods.updateFileUploadData(row.FID, ui.values.DESC, onSuccess_updateFileUploadData, onFail_updateFileUploadData);
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
                         PageMethods.getLogDataByMSID(ui.items[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, ui.items[0].data.MSID);
                     }
                     else if (ui.items.length == 0) {
                         $("#tableLog").empty();
                     }
                 }
             });

             $("#weightDialogBox").igDialog({
                 width: "1000px",
                 height: "500px",
                 state: "closed",
                 closeOnEscape: true
             });

             $("#detailsDialog").igDialog({
                 width: "700px",
                 height: "850px",
                 state: "closed",
                 closeOnEscape: true
             });

             $("#igUploadBOL").igUpload({
                 autostartupload: true,
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelecting: function (evt, ui) { },
                 fileSelected: function (evt, ui) { showProgress(); },
                 fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                     var ctxVal = [];
                     var MSID = $("#detailsDialog").data("data-MSID");
                     ctxVal[0] = ui.filePath;
                     ctxVal[1] = "BOL";
                     ctxVal[2] = MSID;
                     PageMethods.processFileAndData(ui.filePath, "BOL", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                     hideProgress();
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },
                 onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in guardStation.aspx, igUploadBOL"); },

             });

             $("#igUploadOTHER").igUpload({
                 autostartupload: true,
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelecting: function (evt, ui) { },
                 fileSelected: function (evt, ui) { showProgress(); },
                 fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                     var ctxVal = [];
                     var MSID = $("#detailsDialog").data("data-MSID");
                     ctxVal[0] = ui.filePath;
                     ctxVal[1] = "OTHER";
                     ctxVal[2] = MSID;
                     PageMethods.processFileAndData(ui.filePath, "OTHER", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                     hideProgress();
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },
                 onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in guardStation.aspx, igUploadOTHER"); },

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


             PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
             PageMethods.getStatusOptions(onSuccess_getStatusOptions, onFail_getStatusOptions);
             PageMethods.checkIfManualEntryIsEnabled(onSuccess_checkIfManualEntryIsEnabled, onFail_checkIfManualEntryIsEnabled);
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
    <div id="igUploadOTHER" style='display: none;' ></div>

    
    <%-- Log --%>
    <div class="logWindow">
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
    
    <%--Dialog for Weights--%>
    <div id ="weightDialogBox">
        <div><h2 id="lblTitleWeightDialogBox">Weights Associated with PO# - Trailer# - </h2></div>
        <br />
        <table class="tblWeights">
            <tr><td><label id="lblGrossTextDialogBox">Cab In with Trailer & Products (Gross Weight): </label></td>
                <td><button type="button" id="btnGrossWeight" onclick='onClick_GrossWeight()'>Get Gross Weight</button><label id="lblGrossWeight"></label></td>
                <td><span id="undoGrossWeight" class="Mi4_undoIcon" onclick="onClick_undoGrossWeight()"></span></td>
                <td><button type="button" id="btnManualGrossWeight" onclick='onClick_setManualWeight(1)'>Set Manually</button></td>

            </tr>
            <tr><td><label id="lblCab1TextDialogBox">Cab In Only: </label></td>
                <td><button type="button" id="btnCab1Weight" onclick='onClick_Cab1Weight()'>Get Cab In Weight</button><label id="lblCab1Weight"></label></td>
                <td><span id="undoCab1Weight" class="Mi4_undoIcon" onclick="onClick_undoCab1Weight()"></span></td>
                <td><button type="button" id="btnManualCab1Weight" onclick='onClick_setManualWeight(2)'>Set Manually</button></td>
                <td><button type="button" id="btnCalCab1" onclick='onClick_calcWeight(2)'>Calculate Cab In </button></td>

            </tr>
            <tr><td><label id="lblCab2TextDialogBox">Cab Out Only: </label></td>
                <td><button type="button" id="btnCab2Weight" onclick='onClick_Cab2Weight()'>Get Cab Out Weight</button><label id="lblCab2Weight"></label></td>
                <td><span id="undoCab2Weight" class="Mi4_undoIcon" onclick="onClick_undoCab2Weight()"></span></td>
                <td><button type="button" id="btnManualCab2Weight" onclick='onClick_setManualWeight(3)'>Set Manually</button></td>
                <td><button type="button" id="btnCalCab2" onclick='onClick_calcWeight(3)'>Calculate Cab Out </button></td>

            </tr>
            <tr><td><label id="lblCab2wTrailerTextDialogBox">Cab Out w/ Trailer: </label></td>
                <td><button type="button" id="btnCab2wTrailerWeight" onclick='onClick_Cab2wTrailerWeight()'>Get Cab Out with Trailer Weight</button><label id="lblCab2wTrailerWeight"></label></td>
                <td><span id="undoCab2wTrailerWeight" class="Mi4_undoIcon" onclick="onClick_undoCab2wTrailerWeight()"></span></td>
                <td><button type="button" id="btnManualCab2wTrailerWeight" onclick='onClick_setManualWeight(4)'>Set Manually</button></td>
                <td><button type="button" id="btnCalCab2wTrailer" onclick='onClick_calcWeight(4)'>Calculate Cab Out w/ Trailer</button></td>

            </tr>
            <tr><td><label id="lblTrailerTextDialogBox">Trailer Only: </label></td>
                <td><button type="button" id="btnTrailerWeight" onclick='onClick_TrailerWeight()'>Get Trailer Weight</button><label id="lblTrailerWeight"></label></td>
                <td><span id="undoTrailerWeight" class="Mi4_undoIcon" onclick="onClick_undoTrailerWeight()"></span></td>
                <td><button type="button" id="btnManualTrailerWeight" onclick='onClick_setManualWeight(5)'>Set Manually</button></td>
                <td><button type="button" id="btnCalTrailer" onclick='onClick_calcWeight(5)'>Calculate Cab Out w/ Trailer</button></td>

            </tr>
            <tr><td><label id="lblNetTextDialogBox">Net Weight (calculated): </label></td>
                <td><label id="lblNetWeight"></label></td>
                <td><span id="undoNetWeight" class="Mi4_undoIcon" onclick="onClick_undoNetWeight()"></span></td>
                <td></td>
                <td><button type="button" id="btnCalNet" onclick='onClick_calcWeight(6)'>Calculate Net</button></td>
            </tr>
        </table>
        <br/>
        <br/>
        <h2 id="lblNoSamples">No samples have been associated with this PO yet. Product weight cannot be calculated.</h2>
        <div id="SampleWeights"><h2 id="lblSampleWeights">Product Weight</h2>

        <table class="tblPWeights">
            <tr><td><label id="lblProductNet">Product Net: </label></td>
                <td><label id="lblProductNetVal"></label></td>
                <td><label>Pounds</label></td></tr>
            
            <tr><td><label id="lblSpecificGravity">Specific Gravity: </label></td>
                <td><label id="lblSpecificGravityVal"></label></td>
                <td><label> Weight/Volume</label></td></tr>
            
            <tr><td><label id="lblVol">Volume: </label></td>
                <td><label id="lblVolVal"></label></td>
                <td><button type="button" id="btnVolCal" onclick='onClick_calcVol()'>Calculate Volume</button></td></tr>
        </table>
        </div>
        <br />
        <br />
        <button type="button" id="btnCloseWeightDialogBox" onclick='$("#weightDialogBox").igDialog("close")'>Close</button> 
    </div>

    <%--Dialog for driver info--%>
    <div id ="detailsDialog">
        <div class ="detailBox">
        <table class="tblDriverInfo">
            <tr><td><label id="lblDriverNameDetailsDialog">Driver Name: </label></td><td><input type="text" id="txtDriverName" /><label id="lblDriverName"></label></td></tr>
            <tr><td><label id="lblDriverPhoneDetailsDialog">Driver Phone Number (No Dashes): </label></td><td><input type="text" id="txtDriverPhone" /><label id="lblDriverPhone"></label></td></tr>
            <tr><td><label id="lblCarrierInfoDialog">Carrier Info: </label></td><td><textarea id="txtAreaCarrierInfo" maxlength="500"></textarea><label id="lblCarrierInfo""></label></td></tr>
            <tr><td></td></tr>
            <tr><td></td></tr>
            <tr><td><button type="button" id="btnSaveDriverInfo" onclick='onClick_SaveDriverInfo();'>Save Driver Info</button><%--<button type="button" id="btnCancelDriverInfo" onclick='onClick_CloseDriverInfo();'>Cancel Driver Info</button>--%></td>
            <td><p style="display:none; color: red; font-weight: bold;"id="saveDriverInfoText">Driver Info Saved</p></td></tr>
        </table>
        </div>
        <div class="detailBox">
        <table class="tblDriverInfo">
            <tr><td><label id="lblGSComment">Guard Station Comment: </label></td><td><textarea id="txtAreaGSComment" maxlength="250"></textarea></td></tr>
            <tr><td></td></tr>
            <tr><td><button type="button" id="btnSaveGSComment" onclick='onClick_SaveGSComment();'>Save Driver Info</button></td>
            <td><p style="display:none; color: red; font-weight: bold;"id="saveGSComment">Comment Saved</p></td></tr>
        </table>
        </div>

        <div class ="detailBox">
        <h2>BOL files:</h2>
        <table class="ContentExtend">
            <tr><td>BOL:</td><td><div><div id="dBOLcontainer" data-fileID="" style='float:left'><a id="alinkBOL"></a></div><div style='float:right'><div id='dDelBOL'><img src='Images/xclose.png' onclick='onclick_deleteBOL();return false;' height='16' width='16'/></div><div id='dUpBOL' class='uploadBOL'><img src='Images/triangleDown.png' onclick='onclick_addFile("#igUploadBOL_ibb_fp");return false;' height='16' width='16' /></div></div></div></td></tr>
        </table>
        <h2>COFA And Other files:</h2>
        <div class="ContentExtend"><table id="gridFiles" class="ContentExtend"></table></div>
        </div>
        <br />
        <br />
        <button type="button" id="btnCloseDriverInfo" onclick='onClick_CloseDriverInfo();'>Close</button>
    </div>
    <table id="grid"></table> 
     <div id="dwProductDetails">
        <h2><span>PO - Trailer:  <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>
    </asp:Content>