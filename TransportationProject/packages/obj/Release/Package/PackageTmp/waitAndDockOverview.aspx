<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="waitAndDockOverview.aspx.cs" Inherits="TransportationProject.waitAndDockOverview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Dashboard</h2>
    <h3>View trucks and their current location and status. Shows an overall view of what trucks are in the plant, truck activity, incoming trucks and departed trucks for the day.</h3>
    <%--<h2>Today's Scheduled Trucks and Trucks on Site</h2>--%>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <script type="text/javascript">
        
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_BULK_SPOTS = [];
        var GLOBAL_VAN_SPOTS = [];
        var GLOBAL_LOCATION_OPTIONS = [];
        var GLOBAL_GRID_DATA_BULK = [];
        var GLOBAL_GRID_DATA_VAN = [];
        var GLOBAL_GRID_DATA_WAITING = [];
        var GLOBAL_GRID_DATA_SAMPLES = [];
        var GLOBAL_GRID_DATA_INSPECT = [];
        var GLOBAL_GRID_DATA_SCHEDULED = [];
        var GLOBAL_GRID_DATA_RELEASED = [];
        var GLOBAL_GRID_DATA_INYARD = [];
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_STATUS_OPTIONS = [];
        var GLOBAL_DOCK_SPOTS = [];
        var GLOBAL_CELL_TEMPLATE = null;


        <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>
        function openProductDetailDialog(MSID, grid) {
            var PO = $("#" + grid).igGrid("getCellValue", MSID, "PO");
            var trailer = $("#" + grid).igGrid("getCellValue", MSID, "TRAILER");
            var POTrailer = comboPOAndTrailer(PO, trailer);
            PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
            if (POTrailer) {
                $("#dvProductDetailsPONUM").text(POTrailer);
            }
        }

        function openProductDetailDialogTrailer(MSID, Trailer) {
            var PO = $("#inYardGrid").igGrid("getCellValue", Trailer, "PO");
            var POTrailer = comboPOAndTrailer(PO, Trailer);
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
            sendtoErrorPage("Error in waitAndDockOverview.aspx, onFail_getPODetailsFromMSID");
        }

        function formatDockSpotCombo(val) {
            var i, spot;
            for (i = 0; i < GLOBAL_DOCK_SPOTS.length; i++) {
                spot = GLOBAL_DOCK_SPOTS[i];
                if (spot.SPOTID == val) {
                    val = spot.DOCKSPOT;
                }
            }
            return val;
        }
        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatLocationCombo(val) {
            var i, stat;
            for (i = 0; i < GLOBAL_LOCATION_OPTIONS.length; i++) {
                stat = GLOBAL_LOCATION_OPTIONS[i];
                if (stat.LOCATION == val) {
                    val = stat.LOCATIONTEXT;
                }
            }
            return val;
        }
        function formatStatusCombo(val) {
            var i, stat;
            for (i = 0; i < GLOBAL_STATUS_OPTIONS.length; i++) {
                stat = GLOBAL_STATUS_OPTIONS[i];
                if (stat.STATUSID == val) {
                    val = stat.STATUS;
                }
            }
            return val;
        }
        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatBulkCombo(val) {
            var i, bulk;
            for (i = 0; i < GLOBAL_BULK_SPOTS.length; i++) {
                bulk = GLOBAL_BULK_SPOTS[i];
                if (bulk.SPOTID == val) {
                    val = bulk.DOCKSPOT;
                }
            }
            return val;
        }
        //Formatting for igGrid cells to display igCombo text as opposed to igCombo value
        function formatVanCombo(val) {
            var i, van;
            for (i = 0; i < GLOBAL_VAN_SPOTS.length; i++) {
                van = GLOBAL_VAN_SPOTS[i];
                if (van.SPOTID == val) {
                    val = van.VANSPOT;
                }
            }
            return val;
        }
        <%-------------------------------------------------------
         Button click Handlers
         -------------------------------------------------------%>
        function onclick_ShowSamples() {
            $("#dvSamples").show();
            $("#btn_ShowSamples").hide();
            $("#btn_HideSamples").show();
        }
        function onclick_HideSamples() {
            $("#dvSamples").hide();
            $("#btn_HideSamples").hide();
            $("#btn_ShowSamples").show();
        }
        function onclick_ShowInspection() {
            $("#dvInspections").show();
            $("#btn_ShowInspection").hide();
            $("#btn_HideInspection").show();
        }
        function onclick_HideInspection() {
            $("#dvInspections").hide();
            $("#btn_ShowInspection").show();
            $("#btn_HideInspection").hide();
        }
        function onclick_ShowWait() {
            $("#dvWait").show();
            $("#btn_ShowWait").hide();
            $("#btn_HideWait").show();
        }
        function onclick_HideWait() {
            $("#dvWait").hide();
            $("#btn_ShowWait").show();
            $("#btn_HideWait").hide();
        }

        function onclick_ShowBulk() {
            $("#dvBulk").show();
            $("#btn_ShowBulk").hide();
            $("#btn_HideBulk").show();
        }
        function onclick_HideBulk() {
            $("#dvBulk").hide();
            $("#btn_ShowBulk").show();
            $("#btn_HideBulk").hide();
        }
        function onclick_ShowVan() {
            $("#dvVan").show();
            $("#btn_ShowVan").hide();
            $("#btn_HideVan").show();
        }
        function onclick_HideVan() {
            $("#dvVan").hide();
            $("#btn_ShowVan").show();
            $("#btn_HideVan").hide();
        }
        function onclick_ShowScheduled() {
            $("#dvScheduled").show();
            $("#btn_ShowScheduled").hide();
            $("#btn_HideScheduled").show();
        }
        function onclick_HideScheduled() {
            $("#dvScheduled").hide();
            $("#btn_ShowScheduled").show();
            $("#btn_HideScheduled").hide();
        }
        function onclick_ShowReleased() {
            $("#dvReleased").show();
            $("#btn_ShowReleased").hide();
            $("#btn_HideReleased").show();
        }
        function onclick_HideReleased() {
            $("#dvReleased").hide();
            $("#btn_ShowReleased").show();
            $("#btn_HideReleased").hide();
        }
        function onclick_ShowInYard() {
            $("#dvInYard").show();
            $("#btn_ShowYard").hide();
            $("#btn_HideInYard").show();
        }
        function onclick_HideInYard() {
            $("#dvInYard").hide();
            $("#btn_ShowYard").show();
            $("#btn_HideInYard").hide();
        }

        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>
        function onSuccess_getDockSpots(value, ctx, methodName) {
            GLOBAL_DOCK_SPOTS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_DOCK_SPOTS[i] = { "SPOTID": value[i][0], "DOCKSPOT": value[i][1] };
            }
            GLOBAL_DOCK_SPOTS.unshift({ "SPOTID": 0, "DOCKSPOT": "N/A" }) //not sure if this one is being used - AJ
            GLOBAL_DOCK_SPOTS.unshift({ "SPOTID": -999, "DOCKSPOT": "(NONE)" })
            PageMethods.getWaitingAreaData(onSuccess_getWaitingAreaData, onFail_getWaitingAreaData);
        }

        function onFail_getDockSpots(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getDockSpots");
        }

        function onSuccess_getDockSpotsForBulk(value, ctx, methodName) {
            GLOBAL_BULK_SPOTS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_BULK_SPOTS[i] = { "SPOTID": value[i][0], "DOCKSPOT": value[i][1] };
            }
            PageMethods.getDockSpotsForVan(onSuccess_getDockSpotsForVan, onFail_getDockSpotsForVan);

        }

        function onFail_getDockSpotsForBulk(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getDockSpotsForBulk");
        }

        function onSuccess_getDockSpotsForVan(value, ctx, methodName) {
            GLOBAL_VAN_SPOTS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_VAN_SPOTS[i] = { "SPOTID": value[i][0], "VANSPOT": value[i][1] };
            }
            PageMethods.getWaitingAreaData(onSuccess_getWaitingAreaData, onFail_getWaitingAreaData);
        }

        function onFail_getDockSpotsForVan(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getDockSpotsForVan");
        }

        function onSuccess_getLocationOptions(value, ctx, methodName) {
            GLOBAL_LOCATION_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_LOCATION_OPTIONS[i] = { "LOCATION": value[i][0], "LOCATIONTEXT": value[i][1] };
            }
            PageMethods.getStatusOptions(onSuccess_getStatusOptions, onFail_getStatusOptions);
        }

        function onFail_getLocationOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getLocationOptions");
        }

        function onSuccess_getStatusOptions(value, ctx, methodName) {
            GLOBAL_STATUS_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_STATUS_OPTIONS[i] = { "STATUSID": value[i][0], "STATUS": value[i][1] };
            }
            PageMethods.getDockSpots(onSuccess_getDockSpots, onFail_getDockSpots);
        }

        function onFail_getStatusOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getStatusOptions");
        }

        function onSuccess_getWaitingAreaData(returnValue, ctx, methodName) {
            GLOBAL_GRID_DATA_WAITING.length = 0 <%--make empty--%>

            for (i = 0; i < returnValue.length; i++) {
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(returnValue[i][8]);

                GLOBAL_GRID_DATA_WAITING[i] =
                {
                    "MSID": returnValue[i][0], "PO": returnValue[i][1], "TRAILER": returnValue[i][2], "isDROPTRAILER": returnValue[i][3],
                    "STATUS": returnValue[i][4], "isEMPTY": returnValue[i][5], "COMMENT": returnValue[i][6], "EMPTYTIME": returnValue[i][7],
                    "isOpenInCMS": isOpenInCMS, "REJECTED": returnValue[i][9], "DEMURRAGETIME": returnValue[i][10], "TIMEARRIVEDINWAIT": returnValue[i][11]
                }

            }

            PageMethods.getPendSamplesTruckData(onSuccess_getPendSamplesTruckData, onFail_getPendSamplesTruckData);
        }

        function onFail_getWaitingAreaData(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getWaitingAreaData");
        }

        function onSuccess_getPendSamplesTruckData(value, ctx, methodName) {
            GLOBAL_GRID_DATA_SAMPLES.length = 0 <%--make empty--%>

            for (i = 0; i < value.length; i++) {
                var testResult = value[i][4];
                var testText = "";
                if (!checkNullOrUndefined(testResult)) {
                    if (testResult === false) {
                        testText = "NOT APPROVED";
                    }
                    else {
                        testText = "APPROVED - Truck ready to move and load"
                    }
                }
                else {
                    testText = "PROCESSING"
                }

                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][8]);
                GLOBAL_GRID_DATA_SAMPLES[i] =
                {
                    "MSID": value[i][0], "PO": value[i][1], "LOCATION": value[i][2], "SAMPLEID": value[i][3],
                    "TEST": testResult, "TESTTEXT": testText, "TRAILER": value[i][5], "STATUS": value[i][6], "REJECTED": value[i][7],
                    "isOpenInCMS": isOpenInCMS, "DEMURRAGETIME": value[i][9], "PRODUCT": value[i][10], "PRODUCTDETAILS": value[i][11]
                }

            }
            PageMethods.getTruckWithInspectionsDone(onSuccess_getTruckWithInspectionsDone, onFail_getTruckWithInspectionsDone);

        }
        function onFail_getPendSamplesTruckData(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getPendSamplesTruckData");
        }


        function onSuccess_getTruckWithInspectionsDone(value, ctx, methodName) {
            GLOBAL_GRID_DATA_INSPECT.length = 0 <%--make empty--%>

            for (i = 0; i < value.length; i++) {
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][8]);
                GLOBAL_GRID_DATA_INSPECT[i] =
                    {
                        "MSID": value[i][0], "PO": value[i][1], "LOCATION": value[i][2], "REJECTED": value[i][3],
                        "STATUS": value[i][5], "TRAILER": value[i][4], "OPEN": value[i][6], "CLOSE": value[i][7], "isOpenInCMS": isOpenInCMS, "DEMURRAGETIME": value[i][9]
                    };
            }
            PageMethods.getDockBulkData(onSuccess_getDockBulkData, onFail_getDockBulkData);
        }

        function onFail_getTruckWithInspectionsDone(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getTruckWithInspectionsDone");
        }


        function onSuccess_getScheduledTrucks(value, ctx, methodName) {
            GLOBAL_GRID_DATA_SCHEDULED.length = 0 <%--make empty--%>
            var dockSpot = '';
            for (i = 0; i < value.length; i++) {


                var rejected = value[i][7]
                var rejectedText = '';
                if (rejected) {
                    rejectedText = 'Rejected';
                }

                if (checkNullOrUndefined(value[i][10]) == false) {
                    dockSpot = value[i][10];
                }
                else {
                    dockSpot = value[i][11];
                }

                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][12]);

                GLOBAL_GRID_DATA_SCHEDULED[i] =
                    {
                        "MSID": value[i][0], "PO": value[i][1], "ETA": value[i][2], "COMMENTS": value[i][3], "CHECKIN": value[i][4], "CHECKOUT": value[i][5], "TRAILER": value[i][6],
                        "REJECTED": rejected, "REJECTEDTEXT": rejectedText, "LOCATION": value[i][8], "STATUS": value[i][9], "SPOT": dockSpot, "isOpenInCMS": isOpenInCMS,
                        "DEMURRAGETIME": value[i][13], "PRODCOUNT": value[i][14], "PRODID": value[i][15], "PRODDETAIL": value[i][16]
                    };
            }

            PageMethods.getDockVanData(onSuccess_getDockVanData, onFail_getDockVanData);
        }

        function onFail_getScheduledTrucks(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getReleasedTrucksData");
        }


        function onSuccess_getReleasedTrucksData(value, ctx, methodName) {
            GLOBAL_GRID_DATA_RELEASED.length = 0 <%--make empty--%>

            for (i = 0; i < value.length; i++) {


                var rejected = value[i][7]
                var rejectedText = '';
                if (rejected) {
                    rejectedText = 'Rejected';
                }
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][8]);

                GLOBAL_GRID_DATA_RELEASED[i] =
                    {
                        "MSID": value[i][0], "PO": value[i][1], "ETA": value[i][2], "COMMENTS": value[i][3], "CHECKIN": value[i][4], "CHECKOUT": value[i][5], "TRAILER": value[i][6],
                        "REJECTED": rejected, "REJECTEDTEXT": rejectedText, "isOpenInCMS": isOpenInCMS, "PRODCOUNT": value[i][9], "PRODID": value[i][10], "PRODDETAIL": value[i][11]
                    };
            }

            PageMethods.getScheduledTrucks(onSuccess_getScheduledTrucks, onFail_getScheduledTrucks);
        }

        function onFail_getReleasedTrucksData(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getReleasedTrucksData");
        }



        function onSuccess_getDockVanData(value, ctx, methodName) {
            GLOBAL_GRID_DATA_VAN.length = 0 <%--make empty--%>
            var dockSpot;
            for (i = 0; i < value.length; i++) {
                var donetime = false;
                var donetext = "PEND"
                var check = checkNullOrUndefined(value[i][9])
                if (!check) {
                    donetime = true;
                    donetext = "DONE"
                }
                if (checkNullOrUndefined(value[i][3]) == false) {
                    dockSpot = value[i][3];
                }
                else {
                    dockSpot = 0;
                }

                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][6]);

                GLOBAL_GRID_DATA_VAN[i] =
                    {
                        "MSID": value[i][0], "PO": value[i][1], "TRAILER": value[i][2], "TIME": value[i][4],
                        "SPOT": dockSpot, "REJECTED": value[i][5], "isOpenInCMS": isOpenInCMS, "DEMURRAGETIME": value[i][6]
                    };
            }
            <%--After dropdown box data are  retrieved and set to global vars, initialize grid --%>
            PageMethods.getTrailerInYardData(onSuccess_getTrailerinYardData, onFail_getTrailerinYardData);

        }

        function onFail_getDockVanData(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getDockVanData");
        }

        function onSuccess_getTrailerinYardData(returnValue, ctx, methodName) {
            GLOBAL_GRID_DATA_INYARD.length = 0 <%--make empty--%>
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

                GLOBAL_GRID_DATA_INYARD[i] =
                    {
                        "MSID": MSID, "PO": PO, "TRAILER": returnValue[i][2], "STATUS": returnValue[i][3], "isDROPTRAILER": returnValue[i][4],
                        "DROPPEDTIME": returnValue[i][5], "isEMPTY": returnValue[i][6], "COMMENT": returnValue[i][7], "EMPTYTIME": returnValue[i][8], "isOpenInCMS": isOpenInCMS,
                        "DEMURRAGETIME": returnValue[i][10], "PRODCOUNT": returnValue[i][11], "PRODID": returnValue[i][12], "PRODDETAIL": returnValue[i][13]
                    }
            }

            initGrid();
        }
        function onFail_getTrailerinYardData(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getTrailerinYardData");
        }


        function onSuccess_getDockBulkData(value, ctx, methodName) {
            var dockSpot;
            GLOBAL_GRID_DATA_BULK.length = 0 <%--make empty--%>

            for (i = 0; i < value.length; i++) {
                var donetime = false;
                var donetext = "PEND"
                if (!checkNullOrUndefined(value[i][9])) {
                    donetime = true;
                    donetext = "DONE"
                }
                var rejected = value[i][5]
                var rejectedText = '';
                if (rejected) {
                    rejectedText = 'Rejected';
                }

                if (checkNullOrUndefined(value[i][3]) == false) {
                    dockSpot = value[i][3];
                }
                else {
                    dockSpot = 0;
                }

                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][6]);
                GLOBAL_GRID_DATA_BULK[i] =
                    {
                        "MSID": value[i][0], "PO": value[i][1], "TRAILER": value[i][2], "TIME": value[i][4], "SPOT": dockSpot, "REJECTED": value[i][5], "isOpenInCMS": isOpenInCMS, "DEMURRAGETIME": value[i][7]
                    };
            }
            PageMethods.getReleasedTrucksData(onSuccess_getReleasedTrucksData, onFail_getReleasedTrucksData);
        }
        function onFail_getDockBulkData(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getDockBulkData");
        }

        function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }
        function onFail_getLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getLogDataByMSID");
        }
        function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }
        function onFail_getLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getLogDataByMSID");
        }

        function onSuccess_getRequestTypesBasedOnMSID(value, ctx, methodName) {
            if (value) {
                GLOBAL_REQUEST_OPTIONS = [];
                for (i = 0; i < value.length; i++) {
                    GLOBAL_REQUEST_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
                }
                $("#cboxReqTypes").igCombo('option', 'dataSource', GLOBAL_REQUEST_OPTIONS);
                $("#cboxReqTypes").igCombo("dataBind");
            }
        }


        function onFail_getRequestTypesBasedOnMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx, onFail_getRequestTypeBasedOnMSID");
        }

        function onSuccess_getLogList(value, ctx, methodName) {
            GLOBAL_LOG_OPTIONS = [];
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
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getLogList");
        }


        function onSuccess_getColorCellSettings(cellValues, ctx, methodName) {
            GLOBAL_CELL_TEMPLATE = null;

            GLOBAL_CELL_TEMPLATE =
                "{{if ${DEMURRAGETIME} >= " + cellValues[0] + " && ${DEMURRAGETIME} <= " + cellValues[1] + "  }} " +
                "<div class=\"yellowCell\"> . </div> " +
                "{{elseif ${DEMURRAGETIME} >= " + cellValues[1] + " && ${DEMURRAGETIME} <= " + cellValues[2] + "  }} " +
                "<div class=\"orangeCell\"> . </div> " +
                "{{elseif ${DEMURRAGETIME} >= " + cellValues[2] + "}} " +
                "<div class=\"redCell\"> . </div> " +
                "{{/if}}";

            PageMethods.getLocationOptions(onSuccess_getLocationOptions, onFail_getLocationOptions);
        }

        function onFail_getColorCellSettings(value, ctx, methodName) {
            sendtoErrorPage("Error in waitAndDockOverview.aspx onFail_getColorCellSettings");
        }

        <%-------------------------------------------------------
         Error Handlers
         -------------------------------------------------------%>
        function showAlert(args) {
            $("#error-message").html(args.errorMessage).stop(true, true).fadeIn(500).delay(3000).fadeOut(500);
        }

        <%-------------------------------------------------------
        Initialize Infragistics IgniteUI Controls
        -------------------------------------------------------%>
        function initGrid() {
            $("#inYardGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_INYARD,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "TRAILER",
                columns:
                    [
                        { headerText: " ", key: "DEMURRAGETIME", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                         { headerText: "MSID", key: "MSID", dataType: "string", width: "100px" },
                         { headerText: "PO Number", key: "PO", dataType: "string", width: "90px" },
                         { headerText: "Trailer", key: "TRAILER", dataType: "string", width: "150px" },
                         {
                             headerText: "Product", key: "PRODID", dataType: "string", width: "150px",
                             template: "{{if(${PRODCOUNT} == 0 || ${MSID} == '(N/A)' )}} N/A " +
                                        "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                                        "{{else}}Multiple{{/if}}"
                         },
                         { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
                         {
                             headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px",
                             template: "{{if(${PRODCOUNT} == 0 || ${MSID} == '(N/A)' )}} N/A " +
                                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                                            "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialogTrailer(${MSID}, \"${TRAILER}\"); return false;'></div>{{/if}}"
                         },
                         { headerText: "Status", key: "STATUS", dataType: "string", width: "150px" },
                         { headerText: "", key: "isDROPTRAILER", hidden: true, width: "0px" },
                         { headerText: "Drop the Trailer", key: "DROPPEDTIME", dataType: "dateTime", template: "{{if (checkNullOrUndefined(${DROPPEDTIME}) == false)}}<div class ='ColumnContentExtend'>${DROPPEDTIME} </div> {{elseif (${isDROPTRAILER} == true && checkNullOrUndefined(${DROPPEDTIME}) == true)}}<div>Not Dropped</div> {{else}} <div>Not A Drop Trailer</div>{{/if}}", format: "MM/dd/yyyy HH:mm:ss", width: "150px" },
                         { headerText: "", key: "isEMPTY", hidden: true },
                         {
                             headerText: "Empty the Trailer", key: "EMPTYTIME", dataType: "dateTime", template: "{{if (checkNullOrUndefined(${EMPTYTIME}) == false)}}<div class ='ColumnContentExtend'>${EMPTYTIME} </div> {{elseif (${isDROPTRAILER} == true && checkNullOrUndefined(${EMPTYTIME}) == true)}}<div>Not Empty</div> {{else}} <div>Not A Drop Trailer</div>{{/if}}", format: "MM/dd/yyyy HH:mm:ss", width: "150px"
                         },
                         { headerText: "Yard Comments", key: "COMMENT", dataType: "string", width: "200px" }],
                features: [
                 {
                     name: 'Updating',
                     enableAddRow: false,
                     enableDeleteRow: false,
                     editMode: "row",
                     editRowStarting: function (evt, ui) {
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);
                         if (row.MSID == "(N/A)") {
                             return false;
                         }
                         else {
                             PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                             return false;
                         }
                     },
                     columnSettings:
                      [
                          { columnKey: "PRODCOUNT", readOnly: true },
                          { columnKey: "PRODID", readOnly: true },
                          { columnKey: "PRODDETAIL", readOnly: true },
                          { columnKey: "DEMURRAGETIME", readOnly: true },
                          { columnKey: "isOpenInCMS", readOnly: true },
                          { columnKey: "MSID", readOnly: true },
                          { columnKey: "PO", readOnly: true },
                          { columnKey: "TRAILER", readOnly: true },
                          { columnKey: "STATUS", readOnly: true },
                          { columnKey: "DROPPEDTIME", readOnly: true },
                          { columnKey: "EMPTYTIME", readOnly: true },
                          { columnKey: "COMMENT", readOnly: true },
                      ]
                 },
                ]

            }); <%--end of $("#inYardGrid").igGrid({--%>

            $("#releasedGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_RELEASED,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "100px" },
                        {
                            headerText: "Rejected", key: "REJECTEDTEXT", dataType: "string", width: "65px", template: "{{if(${REJECTED})}}" +
                                                "<div class ='needsTruckMove'>${REJECTEDTEXT}</div>{{else}}<div>${REJECTEDTEXT}</div>{{/if}}"
                        },
                        { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                        { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "150px" },
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
                                            "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialog(${MSID},\"releasedGrid\"); return false;'></div>{{/if}}"
                             },
                        { headerText: "Check In", key: "CHECKIN", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "125px" },
                        { headerText: "Check Out", key: "CHECKOUT", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "125px" },
                        { headerText: "Comments", key: "COMMENTS", dataType: "string", width: "300px" }

                    ],
                features: [
                    {
                        name: 'Paging'
                    },
                    {
                        name: 'Resizing'
                    },
                      {
                          name: 'Sorting'
                      },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          editMode: "row",
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.MSID == "(N/A)") {
                                  return false;
                              }
                              else {
                                  PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  return false;
                              }
                          },
                          columnSettings:
                              [
                                  { columnKey: "PRODCOUNT", readOnly: true },
                                  { columnKey: "PRODID", readOnly: true },
                                  { columnKey: "PRODDETAIL", readOnly: true },
                                  { columnKey: "REJECTED", readOnly: true },
                                  { columnKey: "isOpenInCMS", readOnly: true },
                                  { columnKey: "MSID", readOnly: true },
                                  { columnKey: "REJECTEDTEXT", readOnly: true },
                                  { columnKey: "PO", readOnly: true },
                                  { columnKey: "TRAILER", readOnly: true },
                                  { columnKey: "CHECKIN", readOnly: true },
                                  { columnKey: "CHECKOUT", readOnly: true },
                                  { columnKey: "COMMENTS", readOnly: true },

                              ]
                      },
                ]

            }); <%--end of $("#releasedGrid").igGrid({--%>

            $("#scheduledGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_SCHEDULED,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                        { headerText: " ", key: "DEMURRAGETIME", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "100px" },
                        { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                        { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "150px" },
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
                                            "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialog(${MSID},\"scheduledGrid\"); return false;'></div>{{/if}}"
                             },
                        { headerText: "ETA", key: "ETA", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Check In", key: "CHECKIN", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Check Out", key: "CHECKOUT", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Location", key: "LOCATION", dataType: "string", width: "125px", formatter: formatLocationCombo },
                        { headerText: "Status", key: "STATUS", dataType: "string", width: "100px", formatter: formatStatusCombo },
                        { headerText: "Current or Assigned Dock Spot", key: "SPOT", dataType: "number", width: "80px", formatter: formatDockSpotCombo },
                        { headerText: "Comments", key: "COMMENTS", dataType: "string", width: "100px" }

                    ],

                features: [
                    {
                        name: 'Paging'
                    },
                    {
                        name: 'Resizing'
                    },
                      {
                          name: 'Sorting'
                      },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          editMode: "row",
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.MSID == "(N/A)") {
                                  return false;
                              }
                              else {
                                  PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  return false;
                              }
                          },
                          columnSettings:
                              [
                                  { columnKey: "PRODCOUNT", readOnly: true },
                                  { columnKey: "PRODID", readOnly: true },
                                  { columnKey: "PRODDETAIL", readOnly: true },
                                  { columnKey: "DEMURRAGETIME", readOnly: true },
                                  { columnKey: "REJECTED", readOnly: true },
                                  { columnKey: "isOpenInCMS", readOnly: true },
                                  { columnKey: "MSID", readOnly: true },
                                  { columnKey: "PO", readOnly: true },
                                  { columnKey: "ETA", readOnly: true },
                                  { columnKey: "TRAILER", readOnly: true },
                                  { columnKey: "CHECKIN", readOnly: true },
                                  { columnKey: "CHECKOUT", readOnly: true },
                                  { columnKey: "LOCATION", readOnly: true },
                                  { columnKey: "STATUS", readOnly: true },
                                  { columnKey: "SPOT", readOnly: true },
                                  { columnKey: "COMMENTS", readOnly: true },

                              ]
                      },
                ]

            }); <%--end of $("#scheduledGrid").igGrid({--%>


            $("#waitingGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_WAITING,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                        { headerText: " ", key: "DEMURRAGETIME", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                         { headerText: "MSID", key: "MSID", dataType: "number", width: "45px" },
                         { headerText: "PO Number", key: "PO", dataType: "string", width: "90px" },
                         { headerText: "Trailer", key: "TRAILER", dataType: "string", width: "150px" },
                         { headerText: "Status", key: "STATUS", dataType: "string", width: "150px" },
                         { headerText: "", key: "isDROPTRAILER", hidden: true, width: "0px" },
                         { headerText: "", key: "isEMPTY", hidden: true, width: "0px" },
                         { headerText: "Empty the Trailer", key: "EMPTYTIME", dataType: "dateTime", template: "{{if (checkNullOrUndefined(${EMPTYTIME}) == false)}}<div class ='ColumnContentExtend'>${EMPTYTIME} </div> {{elseif (${isDROPTRAILER} === true && checkNullOrUndefined(${EMPTYTIME}) == true)}}<div class ='ColumnContentExtend'> </div> {{else}} <div>Not A Drop Trailer</div>{{/if}}", format: "MM/dd/yyyy HH:mm:ss", width: "150px" },
                         { headerText: "Time Arrive in Wait", key: "TIMEARRIVEDINWAIT", dataType: "dateTime", format: "MM/dd/yyyy HH:mm:ss", width: "150px" },
                         { headerText: "Waiting Area Comments", key: "COMMENT", dataType: "string", width: "200px" }
                    ],
                features: [
                    {
                        name: 'Paging'
                    },
                    {
                        name: 'Resizing'
                    },
                      {
                          name: 'Sorting'
                      },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          editMode: "row",
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.MSID == "(N/A)") {
                                  return false;
                              }
                              else {
                                  PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  return false;
                              }
                          },
                          columnSettings:
                      [
                      { columnKey: "DEMURRAGETIME", readOnly: true },
                          { columnKey: "REJECTED", readOnly: true },
                          { columnKey: "isOpenInCMS", readOnly: true },
                          { columnKey: "MSID", readOnly: true },
                          { columnKey: "TRAILER", readOnly: true },
                          { columnKey: "PO", readOnly: true },
                          { columnKey: "TIME", readOnly: true },
                          { columnKey: "COMMENTS", readOnly: true },

                      ]
                      },
                ]

            }); <%--end of $("#waitingGrid").igGrid({--%>



            $("#bulkGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_BULK,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                        { headerText: " ", key: "DEMURRAGETIME", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "100px" },
                        { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                        { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
                        { headerText: "Time Arrived in Dock", key: "TIME", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "125px" },
                        { headerText: "Dock Spot", key: "SPOT", dataType: "number", width: "80px", formatter: formatDockSpotCombo }
                    ],
                features: [
                    {
                        name: 'Paging'
                    },
                    {
                        name: 'Resizing'
                    },
                      {
                          name: 'Sorting'
                      },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          editMode: "row",
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.MSID == "(N/A)") {
                                  return false;
                              }
                              else {
                                  PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  return false;
                              }
                          },
                          columnSettings:
                             [
                              { columnKey: "DEMURRAGETIME", readOnly: true },
                                 { columnKey: "REJECTED", readOnly: true },
                                 { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "TIME", readOnly: true },
                                 { columnKey: "SPOT", readOnly: true },

                             ]
                      },
                ]

            }); <%--end of $("#bulkGrid").igGrid({--%>



            $("#vanGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_VAN,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                        { headerText: " ", key: "DEMURRAGETIME", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "100px" },
                        { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                        { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
                        { headerText: "Time Arrived in Dock", key: "TIME", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "125px" },
                        { headerText: "Dock Spot", key: "SPOT", dataType: "number", width: "80px", formatter: formatDockSpotCombo }
                    ],
                features: [
                    {
                        name: 'Paging'
                    },
                    {
                        name: 'Resizing'
                    },
                      {
                          name: 'Sorting'
                      },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          editMode: "row",
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.MSID == "(N/A)") {
                                  return false;
                              }
                              else {
                                  PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  return false;
                              }
                          },
                          columnSettings:
                             [
                              { columnKey: "DEMURRAGETIME", readOnly: true },
                                 { columnKey: "REJECTED", readOnly: true },
                                 { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "TIME", readOnly: true },
                                 { columnKey: "SPOT", readOnly: true },
                             ]
                      },
                ]

            }); <%--end of $("#vanGrid").igGrid({--%>





            $("#samplesGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_SAMPLES,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                        { headerText: " ", key: "DEMURRAGETIME", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "100px" },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "100px" },
                        { headerText: "", key: "TEST", dataType: "string", width: "0px", hidden: true },
                        { headerText: "PO", key: "PO", dataType: "number", width: "150px" },
                        { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "150px" },
                        { headerText: "Truck Location", key: "LOCATION", dataType: "string", formatter: formatLocationCombo, width: "125px" },
                        { headerText: "Truck Status", key: "STATUS", dataType: "string", formatter: formatStatusCombo, width: "200px" },
                        { headerText: "Sample ID", key: "SAMPLEID", dataType: "id", width: "200px" },
                        { headerText: "Product", key: "PRODUCT", dataType: "string", width: "150px" },
                        { headerText: "Product", key: "PRODUCTDETAILS", dataType: "string", width: "150px" },
                        {
                            headerText: "Sample Status", key: "TESTTEXT", dataType: "string", width: "100px", template: "{{if(checkNullOrUndefined(${TEST})) === true}}${TESTTEXT} " +
                                "{{elseif ((!checkNullOrUndefined(${TEST})) && (${TEST}) == 'false')}} <div class ='needsTruckMove'>${TESTTEXT}</div> " +
                                "{{else}} " +
                                "<div class ='needsTruckMoveGreen'>${TESTTEXT}</div>" +
                                "{{/if}}"
                        },


                    ],
                features: [
                    {
                        name: 'Paging'
                    },
                    {
                        name: 'Resizing'
                    },
                      {
                          name: 'Sorting'
                      },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.MSID == "(N/A)") {
                                  return false;
                              }
                              else {
                                  PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  return false;
                              }
                          },
                          columnSettings:
                             [
                                 { columnKey: "PRODUCTDETAILS", readOnly: true },
                                 { columnKey: "PRODUCT", readOnly: true },
                                 { columnKey: "DEMURRAGETIME", readOnly: true },
                                 { columnKey: "REJECTED", readOnly: true },
                                 { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "LOCATION", readOnly: true },
                                 { columnKey: "STATUS", readOnly: true },
                                 { columnKey: "SAMPLEID", readOnly: true },
                                 { columnKey: "TESTTEXT", readOnly: true },

                             ]
                      },
                ]

            }); // end of samplesGrid

            $("#inspectionsGrid").igGrid({
                dataSource: GLOBAL_GRID_DATA_INSPECT,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                        { headerText: " ", key: "DEMURRAGETIME", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "100px" },
                        { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                        { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "150px" },
                        { headerText: "Location", key: "LOCATION", dataType: "string", width: "125px", formatter: formatLocationCombo },
                        { headerText: "Status", key: "STATUS", dataType: "string", width: "150px", formatter: formatStatusCombo },
                        { headerText: "Start Or Reopen Time", key: "OPEN", dataType: "datetime", width: "125px", format: "MM/dd/yyyy HH:mm" },
                        { headerText: "Close Time", key: "CLOSE", dataType: "datetime", width: "75px", format: "MM/dd/yyyy HH:mm" }


                    ],
                features: [
                    {
                        name: 'Paging'
                    },
                    {
                        name: 'Resizing'
                    },
                      {
                          name: 'Sorting'
                      },
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          enableDeleteRow: false,
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              if (row.MSID == "(N/A)") {
                                  return false;
                              }
                              else {
                                  PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
                                  return false;
                              }
                          },
                          columnSettings:
                             [
                              { columnKey: "DEMURRAGETIME", readOnly: true },
                                 { columnKey: "REJECTED", readOnly: true },
                                 { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "LOCATION", readOnly: true },
                                 { columnKey: "STATUS", readOnly: true },
                                 { columnKey: "OPEN", readOnly: true },
                                 { columnKey: "CLOSE", readOnly: true },

                             ]
                      },
                ]

            }); // end of inspectionsGrid


        }; <%--end of  function initGrid()  {--%>

        $(function () {
            $("#btn_ShowSamples").hide();
            $("#btn_ShowInspection").hide();
            $("#btn_ShowWait").hide();
            $("#btn_ShowBulk").hide();
            $("#btn_ShowVan").hide();
            $("#btn_ShowScheduled").hide();
            $("#btn_ShowReleased").hide();
            $("#btn_ShowYard").hide();
            $("#btnViewTruck").hide();


            var isMobile = isOnMobile();
            $("#logButton").click(function () {
                var logDisplay = $('#logTableWrapper').css('display');
                truckLog_MiniMaxAndRemember(logDisplay);
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
            PageMethods.getColorCellSettings(onSuccess_getColorCellSettings, onFail_getColorCellSettings);
        });

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

    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideScheduled()" id="btn_HideScheduled" value="Hide Grid" />
            <input type="button" onclick="    onclick_ShowScheduled()" id="btn_ShowScheduled" value="Show Grid" /></div>
        <h2>Today's Scheduled Trucks</h2>
    </div>
    <br />
    <br />
    <div id="dvScheduled">
        <table id="scheduledGrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideInYard()" id="btn_HideInYard" value="Hide Grid" />
            <input type="button" onclick="    onclick_ShowInYard()" id="btn_ShowYard" value="Show Grid" /></div>
        <h2>Trailers In Yard</h2>
    </div>
    <br />
    <br />
    <div id="dvInYard">
        <table id="inYardGrid"></table>
    </div>

    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideSamples()" id="btn_HideSamples" value="Hide Grid" />
            <input type="button" onclick="onclick_ShowSamples()" id="btn_ShowSamples" value="Show Grid" /></div>
        <h2>Trucks With Samples Needed or Pending</h2>
    </div>
    <br />
    <br />
    <div id="dvSamples">
        <table id="samplesGrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideInspection()" id="btn_HideInspection" value="Hide Grid" />
            <input type="button" onclick="onclick_ShowInspection()" id="btn_ShowInspection" value="Show Grid" /></div>
        <h2>Trucks at Inspector</h2>
    </div>
    <br />
    <br />
    <div id="dvInspections">
        <table id="inspectionsGrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideWait()" id="btn_HideWait" value="Hide Grid" />
            <input type="button" onclick="onclick_ShowWait()" id="btn_ShowWait" value="Show Grid" /></div>
        <h2>Waiting Area</h2>
    </div>
    <br />
    <br />
    <div id="dvWait">
        <table id="waitingGrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideBulk()" id="btn_HideBulk" value="Hide Grid" />
            <input type="button" onclick="onclick_ShowBulk()" id="btn_ShowBulk" value="Show Grid" /></div>
        <h2>Dock Bulk</h2>
    </div>
    <br />
    <br />
    <div id="dvBulk">
        <table id="bulkGrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideVan()" id="btn_HideVan" value="Hide Grid" />
            <input type="button" onclick="onclick_ShowVan()" id="btn_ShowVan" value="Show Grid" /></div>
        <h2>Dock Van</h2>
    </div>
    <br />
    <br />
    <div id="dvVan">
        <table id="vanGrid"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideReleased()" id="btn_HideReleased" value="Hide Grid" />
            <input type="button" onclick="onclick_ShowReleased()" id="btn_ShowReleased" value="Show Grid" /></div>
        <h2>Released Trucks</h2>
    </div>
    <br />
    <br />
    <div id="dvReleased">
        <table id="releasedGrid"></table>
    </div>
    <div id="dwProductDetails">
        <h2><span>PO - Trailer:  <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>
</asp:Content>