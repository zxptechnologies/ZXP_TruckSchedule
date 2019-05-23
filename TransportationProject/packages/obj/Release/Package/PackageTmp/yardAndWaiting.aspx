<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="yardAndWaiting.aspx.cs" Inherits="TransportationProject.yardAndWaiting" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Yard and Waiting Area</h2>
    <h3>Shows all trucks and/or trailer that are in the trailer yard and waiting area.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">
        
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_YARD_GRID_DATA = [];
        var GLOBAL_WAIT_GRID_DATA = [];
        var GLOBAL_PO_OPTIONS = [];
        var GLOBAL_LOCATION_OPTIONS = [];
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_HIGHTLIGHT_TEMPLATE;


         <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>
        function onClick_ToYardFromWait(MSID, PKEY) {
            PageMethods.verifyMove(MSID, "WAIT", onSuccess_verifyMove_ToWait, onFail_verifyMove, PKEY);
        }
        function onClick_ToWaitFromYard(MSID) {
            PageMethods.verifyMove(MSID, "YARD", onSuccess_verifyMove_ToYard, onFail_verifyMove, MSID);
        }
        function openProductDetailDialogWait(MSID, grid) {
            var PO = $("#" + grid).igGrid("getCellValue", MSID, "PO");
            var trailer = $("#" + grid).igGrid("getCellValue", MSID, "TRAILER");
            var POTrailer = null;
            POTrailer = comboPOAndTrailer(PO, trailer);
            PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
            if (POTrailer) {
                $("#dvProductDetailsPONUM").text(POTrailer);
            }
        }
        function openProductDetailDialogYard(MSID, PKEY) {
            var TRAILER = $("#yardGrid").igGrid("getCellValue", PKEY, "TRAILER");
            var PO = $("#yardGrid").igGrid("getCellValue", PKEY, "PO");
            var POTrailer = null;
            POTrailer = comboPOAndTrailer(PO, TRAILER);
            PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
            if (POTrailer) {
                $("#dvProductDetailsPONUM").text(POTrailer);
            }
        }

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
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_getPODetailsFromMSID");
        }

        function onSuccess_updateLocation(value, MSID, methodName) {
            PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
            var newLocLong = $("#cboxLocations").igCombo("text");
            $("#lblLocation").html('Current Location: ' + newLocLong);
            $("#lblStatus").html("Current Status: Waiting");
            PageMethods.getWaitGridData(onSuccess_getWaitGridData_Rebind, onFail_getWaitGridData, MSID);
            PageMethods.getYardGridData(onSuccess_getYardGridData_Rebind, onFail_getYardGridData, MSID);
        }
        function onFail_updateLocation(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_updateLocation");
        }

        function onSuccess_getCurrentLocationAndStatus(returnValue, ctx, methodName) {
            $("#lblLocation").html("Current Location: " + returnValue[0]);
            $("#lblStatus").html("Current Status: " + returnValue[1]);
            if (returnValue[0] == "Waiting Area") {
                $("#cboxLocations").igCombo("value", "WAIT");
            }
            else if (returnValue[0][0] == "Trailer Yard") {
                $("#cboxLocations").igCombo("value", "YARD");
            }
        }
        function onFail_getCurrentLocationAndStatus(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_getCurrentLocationAndStatus");
        }

        function onSuccess_getYardGridData(returnValue, ctx, methodName) {
            GLOBAL_YARD_GRID_DATA = [];

            for (i = 0; i < returnValue.length; i++) {
                var isOpenInCMS;
                if (returnValue[i][9] == -1) {
                    isOpenInCMS = formatNegativeOneMSIDToNA(returnValue[i][9]);
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(returnValue[i][9]);
                }

                var MSID = formatNegativeOneMSIDToNA(returnValue[i][0]);
                var PO = formatNegativeOneMSIDToNA(returnValue[i][1]);
                var prodCount = returnValue[i][13];
                var availProdDetail = returnValue[i][15];
                var prodDetail = getreformedProdDataForHTML(MSID, availProdDetail, prodCount);
                var availProdID = returnValue[i][14];
                var prodID = getreformedProdDataForHTML(MSID, availProdID, prodCount);
                var pkey = MSID + "_" + returnValue[i][2];

                GLOBAL_YARD_GRID_DATA[i] = {
                    "MSID": MSID, "MSIDTEXT": MSID, "PO": PO, "TRAILER": returnValue[i][2], "STATUS": returnValue[i][3], "isDROPTRAILER": returnValue[i][4],
                    "DROPPEDTIME": returnValue[i][5], "isEMPTY": returnValue[i][6], "COMMENT": returnValue[i][7], "EMPTYTIME": returnValue[i][8],
                    "isOpenInCMS": isOpenInCMS, "TIMEARRIVEDATYARD": returnValue[i][10], "JUSTINHL": returnValue[i][12], "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail, "PKEY": pkey,
                };
            }
            PageMethods.getWaitGridData(onSuccess_getWaitGridData, onFail_getWaitGridData);
        }

        function getreformedProdDataForHTML(MSID, prodData, prodCount) {
            var newProdData = "";
            if (prodCount === 0 || MSID === '(N/A)') {
                newProdData = "(N/A)"
            }
            else if (prodCount < 2) {
                newProdData = prodData;
            }
            else {
                newProdData = "Multiple"
            }
            return newProdData
        }

        function onSuccess_getYardGridData_Rebind(returnValue, MSID, methodName) {
            GLOBAL_YARD_GRID_DATA = [];

            for (i = 0; i < returnValue.length; i++) {
                var isOpenInCMS;
                if (returnValue[i][9] == -1) {
                    isOpenInCMS = formatNegativeOneMSIDToNA(returnValue[i][9]);
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(returnValue[i][9]);
                }

                var MSID = formatNegativeOneMSIDToNA(returnValue[i][0]);
                var PO = formatNegativeOneMSIDToNA(returnValue[i][1]);
                var prodCount = returnValue[i][13];
                var availProdDetail = returnValue[i][15];
                var prodDetail = getreformedProdDataForHTML(MSID, availProdDetail, prodCount);
                var availProdID = returnValue[i][14];
                var prodID = getreformedProdDataForHTML(MSID, availProdID, prodCount);
                var pkey = MSID + "_" + returnValue[i][2];

                GLOBAL_YARD_GRID_DATA[i] = {
                    "MSID": MSID, "MSIDTEXT": MSID, "PO": PO, "TRAILER": returnValue[i][2], "STATUS": returnValue[i][3], "isDROPTRAILER": returnValue[i][4],
                    "DROPPEDTIME": returnValue[i][5], "isEMPTY": returnValue[i][6], "COMMENT": returnValue[i][7], "EMPTYTIME": returnValue[i][8],
                    "isOpenInCMS": isOpenInCMS, "TIMEARRIVEDATYARD": returnValue[i][10], "JUSTINHL": returnValue[i][12], "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail, "PKEY": pkey,
                };
            }
            $("#yardGrid").igGrid("option", "dataSource", GLOBAL_YARD_GRID_DATA);
            $("#yardGrid").igGrid("dataBind");
            if (MSID > 0) {
                PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
            }
        }
        function onFail_getYardGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_getYardGridData");
        }

        function onSuccess_getWaitGridData(returnValue, ctx, methodName) {
            GLOBAL_WAIT_GRID_DATA = [];
            var rightNow = [];
            rightNow = getNowDateTime().toString();
            for (i = 0; i < returnValue.length; i++) {
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(returnValue[i][8]);
                var MSID = returnValue[i][0];
                var prodCount = returnValue[i][13];
                var availProdDetail = returnValue[i][15];
                var prodDetail = getreformedProdDataForHTML(MSID, availProdDetail, prodCount);
                var availProdID = returnValue[i][14];
                var prodID = getreformedProdDataForHTML(MSID, availProdID, prodCount);

                GLOBAL_WAIT_GRID_DATA[i] = {
                    "MSID": MSID, "MSIDTEXT": MSID, "PO": returnValue[i][1], "TRAILER": returnValue[i][2], "isDROPTRAILER": returnValue[i][3], "STATUS": returnValue[i][4], "isEMPTY": returnValue[i][5],
                    "COMMENT": returnValue[i][6], "EMPTYTIME": returnValue[i][7], "isOpenInCMS": isOpenInCMS, "TIMEARRIVEDATWAIT": returnValue[i][9],
                    "FROMGSTIME": returnValue[i][10], "JUSTINHL": returnValue[i][12], "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail
                };
            }
            PageMethods.getLocationOptions(onSuccess_getLocationOptions, onFail_getLocationOptions);
        }
        function onSuccess_getWaitGridData_Rebind(returnValue, MSID, methodName) {
            GLOBAL_WAIT_GRID_DATA = [];
            var rightNow = [];
            rightNow = getNowDateTime().toString();
            for (i = 0; i < returnValue.length; i++) {
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(returnValue[i][8]);
                var MSID = returnValue[i][0];
                var prodCount = returnValue[i][13];
                var availProdDetail = returnValue[i][15];
                var prodDetail = getreformedProdDataForHTML(MSID, availProdDetail, prodCount);
                var availProdID = returnValue[i][14];
                var prodID = getreformedProdDataForHTML(MSID, availProdID, prodCount);

                GLOBAL_WAIT_GRID_DATA[i] = {
                    "MSID": MSID, "MSIDTEXT": MSID, "PO": returnValue[i][1], "TRAILER": returnValue[i][2], "isDROPTRAILER": returnValue[i][3], "STATUS": returnValue[i][4], "isEMPTY": returnValue[i][5],
                    "COMMENT": returnValue[i][6], "EMPTYTIME": returnValue[i][7], "isOpenInCMS": isOpenInCMS, "TIMEARRIVEDATWAIT": returnValue[i][9],
                    "FROMGSTIME": returnValue[i][10], "JUSTINHL": returnValue[i][12], "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail
                };
            }
            $("#waitGrid").igGrid("option", "dataSource", GLOBAL_WAIT_GRID_DATA);
            $("#waitGrid").igGrid("dataBind");
            if (MSID > 0) {
                PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
            }
        }
        function onFail_getWaitGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_getWaitGridData");
        }

        function onSuccess_getPOOptionsInZXP(returnValue, ctx, methodName) {
            GLOBAL_PO_OPTIONS = [];
            for (i = 0; i < returnValue.length; i++) {
                var POAndTrailer = comboPOAndTrailer(returnValue[i][1], returnValue[i][2]);

                GLOBAL_PO_OPTIONS[i] = { "MSID": returnValue[i][0], "PO": POAndTrailer };
            }
            PageMethods.getYardGridData(onSuccess_getYardGridData, onFail_getYardGridData);
        }
        function onFail_getPOOptionsInZXP(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_getPOOptionsInZXP");
        }

        function onSuccess_getLocationOptions(returnValue, ctx, methodName) {
            GLOBAL_LOCATION_OPTIONS = [];

            for (i = 0; i < returnValue.length; i++) {
                GLOBAL_LOCATION_OPTIONS.push({ "LOC": returnValue[i][0], "LOCTEXT": returnValue[i][1] });
            }

            $("#cboxLocations").igCombo("option", "dataSource", GLOBAL_LOCATION_OPTIONS);
            $("#cboxLocations").igCombo("dataBind");
            initInfragistics();
        }
        function onFail_getLocationOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_getLocationOptions");
        }

        function onSuccess_dropTheTrailer(value, MSID, methodName) {
            var didSucceed = value[0];
            var msg = value[1];
            if (didSucceed) {
                PageMethods.getYardGridData(onSuccess_getYardGridData_Rebind, onFail_getYardGridData);
            }
            else {
                callUpdatePrompt(MSID, msg + " Update trailer number to (max 15 characters): ");
            }
        }

        function callUpdatePrompt(MSID, promptMsg)
        {
            var trailerNum = promptForUpdateTrailerNumber(promptMsg, " ");
            if (checkNullOrUndefined(trailerNum)) {

                alert("No update done.");
            }
            else {

                if (trailerNum.length > 15) {
                    callUpdatePrompt(MSID, "Cannot exceed 15 characters. Update trailer number to (max 15 characters): ");
                }
                else {
                    PageMethods.updateTrailerNumber(trailerNum, MSID, onSuccess_updateTrailerNumber, onFail_updateTrailerNumber);
                    
                }
            }
        }
        function promptForUpdateTrailerNumber(msg)
        {
            var trailernum = prompt(msg, "");
            return trailernum;
        }


        function onFail_dropTheTrailer(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_dropTrailer");
        }

        function onSuccess_updateTrailerNumber(value, ctx, methodName)
        {
            var MSID = ctx;
            PageMethods.dropTheTrailer(MSID, onSuccess_dropTheTrailer, onFail_dropTheTrailer, MSID);
          
        }
        function onFail_updateTrailerNumber(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_updateTrailerNumber");
        }
        

        function onSuccess_emptyTheTrailer(droppedTime, MSID, methodName) {
            PageMethods.getWaitGridData(onSuccess_getWaitGridData_Rebind, onFail_getWaitGridData, MSID);
            PageMethods.getYardGridData(onSuccess_getYardGridData_Rebind, onFail_getYardGridData, MSID);
        }
        function onFail_emptyTheTrailer(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_emptyTheTrailer");
        }

        function onSuccess_getLogList(value, ctx, methodName) {
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    var POTrailerCombo;
                    POTrailerCombo = comboPOAndTrailer(value[i][1], value[i][2]);

                    GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailerCombo });
                    POTrailerCombo = null;
                }
                $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                $("#cboxLogTruckList").igCombo("dataBind");
            }
        }

        function onFail_getLogList(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx onFail_getLogList");
        }

        function onSuccess_verifyMove(returnData, ctx, methodName) {
            if (returnData.length > 0) {
                if (returnData[0] == "true") {
                    var MSIDofSelectedTruck = $("#cboxTruckList").igCombo("value");
                    var newLocation = $("#cboxLocations").igCombo("value");
                    PageMethods.updateLocation(MSIDofSelectedTruck, newLocation, onSuccess_updateLocation, onFail_updateLocation, MSIDofSelectedTruck);
                }
                else {
                    var MSIDofSelectedTruck = $("#cboxTruckList").igCombo("text");
                    var newLocation = $("#cboxLocations").igCombo("text");
                    if (returnData[1] == newLocation) {
                        alert("Cannot move to " + newLocation + " because " + MSIDofSelectedTruck + " is already at that location. Please refresh the page to get the latest data.");
                    }
                    else {
                        alert(MSIDofSelectedTruck + "'s location could not be updated because its current location " + returnData[1] + " and its status is " + returnData[2] + ". If this PO is currently in the middle of a task such as loading, unloading, inspecting, or sampling, the task must be completed before the PO can move.");
                    }
                }
            }
        }

        function onSuccess_verifyMove_ToWait(returnData, PKEY, methodName) {
            if (returnData.length > 0) {
                var MSID = $("#yardGrid").igGrid("getCellValue", PKEY, "MSID");
                if (returnData[0] == "true") {
                    PageMethods.updateLocation(MSID, "WAIT", onSuccess_updateLocation, onFail_updateLocation, MSID);
                }
                else {
                    var PO = $("#yardGrid").igGrid("getCellValue", PKEY, "PO");
                    if (returnData[1] == "WAIT") {
                        alert("Cannot move to wait because " + PO + " is already at that location. Please refresh the page to get the latest data.");
                    }
                    else {
                        alert(PO + "'s location could not be updated because its current location " + returnData[1] + " and its status is " + returnData[2] + ". If this PO is currently in the middle of a task such as loading, unloading, inspecting, or sampling, the task must be completed before the PO can move.");
                    }
                }
            }
        }
        function onSuccess_verifyMove_ToYard(returnData, MSID, methodName) {
            if (returnData.length > 0) {
                if (returnData[0] == "true") {
                    PageMethods.updateLocation(MSID, "YARD", onSuccess_updateLocation, onFail_updateLocation, MSID);
                }
                else {
                    var PO = $("#waitGrid").igGrid("getCellValue", MSID, "PO");
                    if (returnData[1] == "YARD") {
                        alert("Cannot move to yard because " + PO + " is already at that location. Please refresh the page to get the latest data.");
                    }
                    else {
                        alert(PO + "'s location could not be updated because its current location " + returnData[1] + " and its status is " + returnData[2] + ". If this PO is currently in the middle of a task such as loading, unloading, inspecting, or sampling, the task must be completed before the PO can move.");
                    }
                }
            }
        }
        function onFail_verifyMove(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx onFail_verifyMove");
        }

        function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }
        function onFail_getLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx onFail_getLogDataByMSID");
        }

        function onSuccess_setComment(val, CommentType, methodName) {
            if (CommentType == "YARD") {
                $("#yardGrid").igGrid("commit");
            }
            else {
                $("#waitGrid").igGrid("commit");
            }
        }

        function onFail_setComment(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_setComment");
        }

        function onSuccess_undoEmptyTheTrailer(value, MSID, methodName) {
            PageMethods.getWaitGridData(onSuccess_getWaitGridData_Rebind, onFail_getWaitGridData, MSID);
            PageMethods.getYardGridData(onSuccess_getYardGridData_Rebind, onFail_getYardGridData, MSID);
        }
        function onFail_undoEmptyTheTrailer(value, MSID, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_undoEmptyTheTrailer");
        }
        function onSuccess_undoDropTheTrailer(value, MSID, methodName) {
            PageMethods.getWaitGridData(onSuccess_getWaitGridData_Rebind, onFail_getWaitGridData, MSID);
            PageMethods.getYardGridData(onSuccess_getYardGridData_Rebind, onFail_getYardGridData, MSID);
        }
        function onFail_undoDropTheTrailer(value, MSID, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_undoDropTheTrailer");
        }

        function onClick_dropTheTrailer(MSID) {
            PageMethods.dropTheTrailer(MSID, onSuccess_dropTheTrailer, onFail_dropTheTrailer, MSID);
        }

        function onClick_emptyTheTrailer(MSID) {
            PageMethods.verifyIfInspectionIsDoneBeforeUnload(MSID, onSuccess_verifyIfInspectionIsDoneBeforeUnload, onFail_verifyIfInspectionIsDoneBeforeUnload, MSID);
        }

        function onClick_undoEmpty(MSID) {
            PageMethods.undoEmptyTheTrailer(MSID, onSuccess_undoEmptyTheTrailer, onFail_undoEmptyTheTrailer, MSID);
        }

        function onClick_undoDrop(MSID) {
            PageMethods.undoDropTheTrailer(MSID, onSuccess_undoDropTheTrailer, onFail_undoDropTheTrailer, MSID);
        }

        function onclick_btnUpdateLocation() {
            var MSIDofSelectedTruck = $("#cboxTruckList").igCombo("value");
            var newLocation = $("#cboxLocations").igCombo("value");
            PageMethods.verifyMove(MSIDofSelectedTruck, newLocation, onSuccess_verifyMove, onFail_verifyMove, MSIDofSelectedTruck);
        }

        function onclick_btncloseLocation() {
            $("#locationOptionsWrapper").hide();
            $("#locationLabelWrapper").hide();
        }
        function onSuccess_verifyIfInspectionIsDoneBeforeUnload(returnString, MSID, methodName) {
            if (checkNullOrUndefined(returnString) == true) {
                PageMethods.emptyTheTrailer(MSID, onSuccess_emptyTheTrailer, onFail_emptyTheTrailer, MSID);
            }
            else {
                switch (returnString) {
                    case "hasNotStartedInspections":
                        alert("There are no inspections on record for this order. Inspections must be done before you can empty the trailer.")
                        break;
                    case "hasOpenInspections":
                        alert("This order still has open inspections. All inspections must be closed before you can empty the trailer.")
                        break;
                }
            }
        }

        function onFail_verifyIfInspectionIsDoneBeforeUnload(value, ctx, methodName) {
            sendtoErrorPage("Error in yardAndWait.aspx, onFail_verifyIfInspectionIsDoneBeforeUnload");
        }

        $(function () {
            PageMethods.getPOOptionsInZXP(onSuccess_getPOOptionsInZXP, onFail_getPOOptionsInZXP);
            $("#dwProductDetails").igDialog({
                width: "650px",
                height: "550px",
                state: "closed",
                modal: true,
                draggable: false
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

            var isMobile = isOnMobile();
            $("#logButton").click(function () {
                var logDisplay = $('#logTableWrapper').css('display');
                truckLog_MiniMaxAndRemember(logDisplay);
            });
        });


         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
        function initInfragistics() {
            $("#yardGrid").igGrid({
                dataSource: GLOBAL_YARD_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: true,
                renderCheckboxes: true,
                primaryKey: "PKEY",
                columns:
                    [
                        {
                            headerText: "", key: "MOVE", width: "20px", template:
                                "{{if (${MSID} != '(N/A)')}}<a href=\"#\"><div class=\"tooltip\"><img id = 'CameraImg' src ='Images/10p_downarrow.png' onclick='onClick_ToYardFromWait(${MSID}, \"${PKEY}\"); return false;'/><span class=\"tooltiptext\">Move To Waiting Area</span><\div><\a>{{/if}}"
                        },
                         {
                             headerText: "Just In From Guard Station", key: "JUSTINHL", width: "100px", template: "{{if(${JUSTINHL} == 1)}} " +
                                                                                                        "<div class=\"yellowCell\">From Guard Station</div> " +
                                                                                                        "{{else}} " +
                                                                                                        "<div> </div>  {{/if}}"
                         },
                        { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                        { headerText: "", key: "PKEY", dataType: "string", width: "0px" },
                        { headerText: "", key: "MSID", dataType: "string", width: "0px" },
                        { headerText: "MSID", key: "MSIDTEXT", dataType: "string", width: "0px" },
                        { headerText: "PO Number", key: "PO", dataType: "string", width: "90px" },
                        { headerText: "Trailer", key: "TRAILER", dataType: "string", width: "150px" },
                            {
                                headerText: "Product", key: "PRODID", dataType: "string", width: "150px"
                            },
                            { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
                            {
                                headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px",
                                template: "{{if(${PRODDETAIL} === 'Multiple') }}<div><input type='button' value='Multiple' onclick='openProductDetailDialogYard(${MSID}, \"${PKEY}\"); return false;'></div>" +
                                           "{{else}}${PRODDETAIL}{{/if}}"
                            },
                        { headerText: "Time Arrive in Yard", key: "TIMEARRIVEDATYARD", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "150px" },
                        { headerText: "Status", key: "STATUS", dataType: "string", width: "150px" },
                        { headerText: "", key: "isDROPTRAILER", dataType: "bool", hidden: true, width: "0px" },
                        {
                            headerText: "Drop the Trailer", key: "DROPPEDTIME", dataType: "date", template: "{{if (checkNullOrUndefined(${DROPPEDTIME}) === false)}}<div class ='ColumnContentExtend'>${DROPPEDTIME} <span class='Mi4_undoIcon' onclick='onClick_undoDrop(${MSID})'></span> </div> " +
                              "{{elseif (${isDROPTRAILER} === true && checkNullOrUndefined(${DROPPEDTIME}) === true)}}<div class ='ColumnContentExtend'> <input id='btnDrop' type='button' value='Drop the Trailer' onclick='onClick_dropTheTrailer(${MSID});' class='ColumnContentExtend'> </div> " +
                              "{{else}} <div>Not A Drop Trailer</div>{{/if}}", format: "MM/dd/yyyy HH:mm:ss", width: "150px"
                        },
                        { headerText: "", key: "isEMPTY", hidden: true },
                        {
                            headerText: "Is Trailer Empty", key: "EMPTYTIME", dataType: "object",
                            template: "{{if (checkNullOrUndefined(${EMPTYTIME}) === false)}}<div class ='ColumnContentExtend'>Yes<span class='Mi4_undoIcon' onclick='onClick_undoEmpty(${MSID})'></span> </div> " +
                            "{{elseif (${isDROPTRAILER} === true && checkNullOrUndefined(${EMPTYTIME}) === true)}}<div class ='ColumnContentExtend'> <input id='btnEmpty' type='button' value='Is Trailer Empty?' onclick='onClick_emptyTheTrailer(${MSID});' class='ColumnContentExtend'> </div> " +
                            "{{else}} <div>Not A Drop Trailer</div>{{/if}}", width: "150px"
                        },
                        { headerText: "Yard Comments", key: "COMMENT", dataType: "string", width: "200px" }
                    ],
                features: [
                    {
                        name: 'Resizing'
                    },
                    {
                        name: "Filtering",
                        allowFiltering: true,
                        caseSensitive: false,
                        columnSettings: [
                                     { columnKey: 'TIMEARRIVEDATYARD', condition: 'on' },
                                     { columnKey: 'DROPPEDTIME', allowFiltering: false },
                                     { columnKey: 'EMPTYTIME', allowFiltering: false },
                        ],
                        dataFiltering: function (evt, ui) {

                            var newThng = [];
                            var nExpressions = [];
                            var check = ui.expressions;
                            for (i = 0; i < ui.newExpressions.length; i++) {
                                var newcond = ui.newExpressions[i].cond;
                                var newExpr = ui.newExpressions[i].expr;
                                var newFieldName = ui.newExpressions[i].fieldName;

                                if (!checkNullOrUndefined(newExpr)) {
                                    if (newFieldName.contains("TIMEARRIVEDATYARD")) {
                                        ui.newExpressions[i].preciseDateFormat = null;
                                    }

                                    nExpressions.push(ui.newExpressions[i]);
                                }
                            }
                            $("#yardGrid").igGridFiltering("filter", nExpressions);
                            return false;
                        },
                    },
                    {
                        name: 'Sorting'
                    },
                     {
                         name: 'Updating',
                         enableAddRow: false,
                         editMode: "row",
                         enableDeleteRow: false,
                         autoCommit: false,
                         editRowStarting: function (evt, ui) {
                             var row = ui.owner.grid.findRecordByKey(ui.rowID);
                             if (row.MSID == "(N/A)") {
                                 alert("You cannot add a comment to a solo trailer that has no order associated to it.");
                                 return false;
                             }
                             else {
                                 PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                             }
                         },
                         editRowEnding: function (evt, ui) {
                             var origEvent = evt.originalEvent;
                             if (typeof origEvent === "undefined") {
                                 ui.keepEditing = true;
                                 return false;
                             }
                             if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) && ui.values.MSID != "(N/A)") {
                                 PageMethods.setComment(ui.values.MSID, ui.values.COMMENT, "YARD", onSuccess_setComment, onFail_setComment, "YARD");
                                 PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
                             }
                             else if (ui.values.MSID == "(N/A)") {
                                 alert("You cannot add a comment to a solo trailer that has no order  associated to it.");
                                 return false;
                             }
                             else {
                                 return false;
                             }
                         },
                         columnSettings:
                             [
                                 { columnKey: "MOVE", readOnly: true },
                                 { columnKey: "PRODCOUNT", readOnly: true },
                                 { columnKey: "JUSTINHL", readOnly: true },
                                 { columnKey: "PRODID", readOnly: true },
                                 { columnKey: "PRODDETAIL", readOnly: true },
                                 { columnKey: "TIMEARRIVEDATYARD", readOnly: true },
                                 { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "MSIDTEXT", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                 { columnKey: "STATUS", readOnly: true },
                                 { columnKey: "DROPPEDTIME", readOnly: true },
                                 { columnKey: "EMPTYTIME", readOnly: true },
                             ]
                     }
                ]
            }); <%--end of $("#yardGrid").igGrid({--%>

             $("#waitGrid").igGrid({
                 dataSource: GLOBAL_WAIT_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: true,
                 renderCheckboxes: true,
                 primaryKey: "MSID",
                 columns:
                     [
                        {
                            headerText: "", key: "MOVE", width: "20px", template:
                                "{{if (${MSID} != '(N/A)')}}<a href=\"#\"><div class=\"tooltip\"><img id = 'CameraImg' src ='Images/10p_uparrow.png' onclick='onClick_ToWaitFromYard(${MSID}); return false;'/><span class=\"tooltiptext\">Move To Trailer Yard</span></div></a>{{/if}}"
                        },
                         {
                             headerText: "Just In From Guard Station", key: "JUSTINHL", width: "100px", template: "{{if(${JUSTINHL} == 1)}} " +
                                                                                                        "<div class=\"yellowCell\">From Guard Station</div> " +
                                                                                                        "{{else}} " +
                                                                                                        "<div> </div>  {{/if}}"
                         },
                         { headerText: "", key: "FROMGSTIME", hidden: true, width: "0px" },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                         { headerText: "", key: "MSID", dataType: "number", width: "0px" },
                         { headerText: "MSID", key: "MSIDTEXT", dataType: "string", width: "0px" },
                         { headerText: "PO Number", key: "PO", dataType: "string", width: "90px" },
                         { headerText: "Trailer", key: "TRAILER", dataType: "string", width: "150px" },
                             {
                                 headerText: "Product", key: "PRODID", dataType: "string", width: "150px"
                             },
                             { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
                             {
                                 headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px",
                                 template: "{{if(${PRODDETAIL} === 'Multiple') }}<div><input type='button' value='Multiple' onclick='openProductDetailDialogWait(${MSID}, \"waitGrid\"); return false;'></div>" +
                                            "{{else}}${PRODDETAIL}{{/if}}",
                             },
                         { headerText: "Time Arrive in Wait", key: "TIMEARRIVEDATWAIT", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "150px" },
                         { headerText: "Status", key: "STATUS", dataType: "string", width: "150px" },
                         { headerText: "", key: "isDROPTRAILER", hidden: true, width: "0px" },
                         { headerText: "", key: "isEMPTY", hidden: true, width: "0px" },
                         {
                             headerText: "Is Trailer Empty", key: "EMPTYTIME", dataType: "object",
                             template: "{{if (checkNullOrUndefined(${EMPTYTIME}) === false)}}<div class ='ColumnContentExtend'>Yes<span class='Mi4_undoIcon' onclick='onClick_undoEmpty(${MSID})'></span> </div> " +
                                 "{{elseif (${isDROPTRAILER} === true && checkNullOrUndefined(${EMPTYTIME}) === true)}}<div class ='ColumnContentExtend'> <input id='btnEmpty' type='button' value='Is Trailer Empty?' onclick='onClick_emptyTheTrailer(${MSID});' class='ColumnContentExtend'> </div> " +
                                 "{{else}} <div>Not A Drop Trailer</div>{{/if}}", width: "150px"
                         },
                         { headerText: "Waiting Area Comments", key: "COMMENT", dataType: "string", width: "200px" }
                     ],
                 features: [
                     {
                         name: 'Resizing'
                     },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                         columnSettings: [
                                      { columnKey: 'TIMEARRIVEDATWAIT', condition: 'on' },
                                      { columnKey: 'EMPTYTIME', allowFiltering: false },
                         ],
                         dataFiltering: function (evt, ui) {
                             var newThng = [];
                             var nExpressions = [];
                             var check = ui.expressions;
                             for (i = 0; i < ui.newExpressions.length; i++) {
                                 var newcond = ui.newExpressions[i].cond;
                                 var newExpr = ui.newExpressions[i].expr;
                                 var newFieldName = ui.newExpressions[i].fieldName;

                                 if (!checkNullOrUndefined(newExpr)) {
                                     if (newFieldName.contains("TIMEARRIVEDATWAIT")) {
                                         ui.newExpressions[i].preciseDateFormat = null;
                                     }

                                     nExpressions.push(ui.newExpressions[i]);
                                 }
                             }
                             $("#waitGrid").igGridFiltering("filter", nExpressions);
                             return false;
                         },
                     },
                     {
                         name: 'Sorting'
                     },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          autoCommit: false,
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                          },
                          editRowEnding: function (evt, ui) {
                              var origEvent = evt.originalEvent;
                              if (typeof origEvent === "undefined") {
                                  ui.keepEditing = true;
                                  return false;
                              }
                              if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                  PageMethods.setComment(ui.rowID, ui.values.COMMENT, "WAIT", onSuccess_setComment, onFail_setComment, "WAIT");
                                  PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
                              }
                              else {
                                  return false;
                              }
                          },
                          columnSettings:
                              [
                                  { columnKey: "MOVE", readOnly: true },
                                  { columnKey: "MSIDTEXT", readOnly: true },
                                  { columnKey: "PRODCOUNT", readOnly: true },
                                  { columnKey: "PRODID", readOnly: true },
                                  { columnKey: "PRODDETAIL", readOnly: true },
                                  { columnKey: "JUSTINHL", readOnly: true },
                                  { columnKey: "TIMEARRIVEDATWAIT", readOnly: true },
                                  { columnKey: "isOpenInCMS", readOnly: true },
                                  { columnKey: "MSID", readOnly: true },
                                  { columnKey: "PO", readOnly: true },
                                  { columnKey: "TRAILER", readOnly: true },
                                  { columnKey: "STATUS", readOnly: true },
                                  { columnKey: "EMPTYTIME", readOnly: true },
                              ]
                      }
                 ]
             }); <%--end of $("#waitGrid").igGrid({--%>


             $("#cboxTruckList").igCombo({
                 dataSource: GLOBAL_PO_OPTIONS,
                 textKey: "PO",
                 valueKey: "MSID",
                 width: "200px",
                 enableClearButton: false,
                 mode: "editable",
                 highlightMatchesMode: "contains",
                 filteringCondition: "contains",
                 autoSelectFirstMatch: false,
                 selectionChanged: function (evt, ui) {
                     if (ui.items.length > 0) {
                         var MSID = ui.items[0].data.MSID;
                         $("#locationOptionsWrapper").show();
                         $("#locationLabelWrapper").show();
                         PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
                         PageMethods.getCurrentLocationAndStatus(MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus);
                     }

                     else {
                         $("#locationOptionsWrapper").hide();
                         $("#locationLabelWrapper").hide();
                     }
                 },
             });


             $("#cboxLocations").igCombo({
                 dataSource: GLOBAL_LOCATION_OPTIONS,
                 textKey: "LOCTEXT",
                 valueKey: "LOC",
                 width: "200px",
                 autoComplete: true,
                 enableClearButton: false,
                 selectionChanging: function (evt, ui) {

                 },
                 selectionChanged: function (evt, ui) {
                 }
             });
             $("#locationOptionsWrapper").hide();
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

             PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
         };<%--function initGrid(){--%>



    </script>



    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="logWindow">
        <div class="logTitleBar">
            <div id="logButton">
                <div id="tLogMax" style="display: none">
                    <img src='Images/tLogMaxi.png' id="maxiIcon" /></div>
                <div id="tLogMini">
                    <img src='Images/tLogMini.png' id="miniIcon" /></div>
            </div>
            Truck Log
        </div>
        <div id="logTableWrapper">
            <input id="cboxLogTruckList" />
            <div id="tableLog"></div>
        </div>
    </div>


    <h2>Select PO - Trailer Number to Update Location</h2>
    <div>
        <input id="cboxTruckList" /></div>
    <br />
    <br />

    <div id="locationLabelWrapper">
        <label id="lblLocation"></label>
        <br />
        <label id="lblStatus"></label>
    </div>

    <div id="locationOptionsWrapper">
        <h2>Update Location</h2>
        <table style="border: 0;">
            <tr>
                <td>
                    <input id="cboxLocations" /></td>
                <td>
                    <button type="button" id="btn_updateLocation" onclick='onclick_btnUpdateLocation();'>Update Location</button></td>
                <td>
                    <button type="button" id="btn_closeLocation" onclick='onclick_btncloseLocation();'>Close Location Information</button></td>
            </tr>
        </table>
    </div>

    <div id="yardGridWrapper">
        <h2>Trailers in yard</h2>
        <table id="yardGrid"></table>
    </div>
    <div id="waitGridWrapper">
        <h2>Trailers in waiting area</h2>
        <table id="waitGrid"></table>
    </div>
    <div id="dwProductDetails">
        <h2><span>PO - Trailer:  <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>
</asp:Content>
