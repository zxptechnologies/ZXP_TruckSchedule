<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="dockManager.aspx.cs" Inherits="TransportationProject.dockManager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="Scripts/gridCreator.js"></script>
    <script src="Scripts/Mi4_Infragistics_Control_Helpers.js"></script>
    <script src="Scripts/GridTemplates/DockManager_YardmuleGrid.js"></script>
    <script src="Scripts/GridTemplates/DockManager_LoaderGrid.js"></script>
    <script src="Scripts/GridTemplates/DockManager_CompletedGrid.js"></script>
    <link href="Content/scheduleGrid.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Dock Manager</h2>
    <h3>Create, edit, and view current requests for loaders and yard mule. Shows the status of open requests and all completed requests for the day.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ScriptMode="Release">
        <Scripts>
        </Scripts>
    </asp:ScriptManager>

    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_ASSIGNEES_OPTIONS = [];
        var GLOBAL_LOADER_OPTIONS = [];
        var GLOBAL_REQUEST_LOADER_OPTIONS = [];
        var GLOBAL_REQUEST_YM_OPTIONS = [];
        var GLOBAL_REQUEST_OPTIONS = [];
        var GLOBAL_REQUEST_OPTIONS_FORMATTER = [];
        var GLOBAL_YARDMULE_OPTIONS = [];
        var GLOBAL_LOADER_PO_OPTIONS = [];
        var GLOBAL_YARDMULE_PO_OPTIONS = [];
        var GLOBAL_SPOT_OPTIONS = [];
        var GLOBAL_SPOT_OPTIONS_FORMATTER = [];
        var GLOBAL_LOADER_DATA = [];
        var GLOBAL_YARDMULE_DATA = [];
        var GLOBAL_COMPLETE_DATA = [];
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_PERSON_OPTIONS = [];
        var GLOBAL_AVAILABLE_TRAILERS = [];
        var GLOBAL_ISDIALOG_OPEN = false;
        var GLOBAL_MSIDForRequestWithOutMSID = '(N/A)';

        <%--Keep synced with table RequestPersonTypes--%>
        var globalPersonType = (function () {
            var g =
            {
                <%--key for RequestPersonType: value of RequestPersonTypeID--%>
                REQUESTPERSON_LOADER: 1,
                REQUESTPERSON_YARDMULE: 2
            };
            return g;
        })();

        <%--Keep synced with table RequestTypes--%>
        var globalRequestType = (function () {
            var g =
            {
                <%--key for RequestType: value of RequestTypeID--%>
                REQUESTTYPE_LOAD: 1,
                REQUESTTYPE_UNLOAD: 2,
                REQUESTTYPE_OTHER: 3,
                REQUESTTYPE_MOVE: 4,
                REQUESTTYPE_MOVEDROPTRAILER: 5
            };
            return g;
        })();


        <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>

        $(window).resize(function () {

            $("#dwSchedule").dialog("option", "position", "center");

        });

        function openProductDetailDialogYM(MSID, rowID) {
            if (MSID != -1) {
                var PO = $("#yardmulegrid").igGrid("getCellValue", rowID, "PO");
                var trailerNum = $("#yardmulegrid").igGrid("getCellValue", rowID, "TRAILNUM");
                var POTrailerCombo = comboPOAndTrailer(PO, trailerNum);
                PageMethods.GetPODetailsFromMSID(MSID, onSuccess_GetPODetailsFromMSID, onFail_GetPODetailsFromMSID, MSID);
                if (PO) {
                    $("#dvProductDetailsPONUM").text(POTrailerCombo);
                }

            }
        }
        function openProductDetailDialogLoader(rowID) {
            var POAndTrailer = $("#loadergrid").igGrid("getCellValue", rowID, "MSID");
            var MSID = $("#loadergrid").igGrid("getCellValue", rowID, "MSIDTEXT");
            if (MSID) {
                PageMethods.GetPODetailsFromMSID(MSID, onSuccess_GetPODetailsFromMSID, onFail_GetPODetailsFromMSID, MSID);
                if (POAndTrailer) {
                    $("#dvProductDetailsPONUM").text(POAndTrailer);
                }
            }
        }

        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        <%-- turns MSID to associated PO --%>
        function formatYardmulePOCombo(val) {
            var i, temp;
            for (i = 0; i < GLOBAL_YARDMULE_PO_OPTIONS.length; i++) {
                temp = GLOBAL_YARDMULE_PO_OPTIONS[i];
                if (temp.ID == val) {
                    val = temp.LABEL;
                    return val;
                }
            }
        }
        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        <%-- turns MSID to associated PO --%>
        function formatLoaderPOCombo(val) {
            var i, temp;
            for (i = 0; i < GLOBAL_LOADER_PO_OPTIONS.length; i++) {
                temp = GLOBAL_LOADER_PO_OPTIONS[i];
                if (temp.ID == val) {
                    val = temp.LABEL;
                    return val;
                }
            }
        }

        //Formatting for igGrid cells to display igCombo text as opposed to igCombo value
        function formatYardmuleCombo(val) {
            var i, ym;
            for (i = 0; i < GLOBAL_YARDMULE_OPTIONS.length; i++) {
                ym = GLOBAL_YARDMULE_OPTIONS[i];
                if (ym.VALUE == val) {
                    val = ym.TEXT;
                    return val;
                }
            }
        }
        //Formatting for igGrid cells to display igCombo text as opposed to igCombo value
        function formatLoaderCombo(val) {
            var i, loader;
            for (i = 0; i < GLOBAL_LOADER_OPTIONS.length; i++) {
                loader = GLOBAL_LOADER_OPTIONS[i];
                if (loader.VALUE == val) {
                    val = loader.TEXT;
                    return val;
                }
            }
        }

        function formatSpotCombo(val) {
            var i, spot;
            for (i = 0; i < GLOBAL_SPOT_OPTIONS_FORMATTER.length; i++) {
                spot = GLOBAL_SPOT_OPTIONS_FORMATTER[i];
                if (spot.ID == val) {
                    val = spot.LABEL;
                    return val;

                }
            }

            return val;
        }

        function formatRequestCombo(val) {
            var i, req;
            for (i = 0; i < GLOBAL_REQUEST_OPTIONS_FORMATTER.length; i++) {
                req = GLOBAL_REQUEST_OPTIONS_FORMATTER[i];
                if (req.ID == val) {
                    val = req.LABEL;
                    return val;
                }
            }
        }


        function init_grid() {
            
            init_yardmuleGrid();
            init_completedGrid();
            init_loaderGrid();
        }
        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>
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
            sendtoErrorPage("Error in dockManager.aspx, onFail_GetPODetailsFromMSID");
        }
        function onSuccess_GetLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }

        function onFail_GetLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx onFail_GetLogDataByMSID");
        }

        function onSuccess_getRequestTypesBasedOnMSID(value, MSID, methodName) {
            if (value) {
                GLOBAL_REQUEST_OPTIONS = [];

                for (i = 0; i < value.length; i++) {
                    GLOBAL_REQUEST_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
                }
                $("#cboxReqTypes").igCombo('option', 'dataSource', GLOBAL_REQUEST_OPTIONS);
                $("#cboxReqTypes").igCombo("dataBind");
            }
            PageMethods.getDataForAddNewRow(MSID, onSuccess_getDataForAddNewRowForLoader, onFail_getDataForAddNewRow);
        }

        function onFail_getRequestTypesBasedOnMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getRequestTypeBasedOnMSID");
        }

        function onSuccess_GetLogList(value, ctx, methodName) {
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

        function onFail_GetLogList(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx onFail_GetLogList");
        }

        function onSuccess_checkStatusOfYMRequest(value, updateType, methodName) {
            <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
            if (value.length) {
                var reqID = value[0][0];
                var eventType = value[0][1];
                var date = formatDate(value[0][2]);
                var assigneeName = value[0][3];
                var MSID = $("#yardmulegrid").igGrid("getCellValue", reqID, "MSIDTEXT");
                var PONUM;
                var r;
                if (MSID == 'N/A') {
                    PONUM = 'N/A';
                    MSID = -1;
                }
                else {
                    PONUM = $("#yardmulegrid").igGrid("getCellValue", reqID, "POANDTRAILERNUM");
                }
                if (updateType == 'delete') {
                    if (eventType == 17) {<%--Request has been created.--%>
                        r = confirm("Continue deleting request for " + PONUM + "? Deletion cannot be undone.");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestYardmule, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 21) { <%--Request has been started.--%>
                        r = confirm(assigneeName + " has started the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestYardmule, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 18) { <%--Request has been completed.--%>
                        r = confirm(assigneeName + " has completed the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestYardmule, onFail_deleteRequest);
                        }
                    }
                }

                else if (updateType == 'update') {
                    if (eventType == 17) {<%--Request has been created.--%>
                        $("#yardmulegrid").data("data-RequestStatus", 'created');
                    }
                    else if (eventType == 21) { <%--Request has been started.--%>
                        alert("You can no longer edit this request because " + assigneeName + " has started it " + date + ".");
                        $("#yardmulegrid").data("data-RequestStatus", 'started');
                    }
                    else if (eventType == 18) { <%--Request has been completed.--%>
                        alert("You can no longer edit this request because " + assigneeName + " has completed it " + date + ".");
                        $("#yardmulegrid").data("data-RequestStatus", 'completed');
                    }
                }
            }
            else {
                <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
                alert("The request you are attempting to update has been deleted or has been completed. Please refresh the page to get the current status of all request.");
            }
        }
        function onFail_checkStatusOfYMRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkStatusOfYMRequest");
        }


        function onSuccess_checkStatusOfLoaderRequest(value, updateType, methodName) {
            <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
            if (value.length) {
                var reqID = value[0][0];
                var eventType = value[0][1];
                var date = formatDate(value[0][2]);
                var assigneeName = value[0][3];
                var MSID = $("#loadergrid").igGrid("getCellValue", reqID, "MSIDTEXT");
                var r;
                var PONUM = $("#loadergrid").igGrid("getCellValue", reqID, "POANDTRAILERNUM");
                if (updateType == 'delete') {
                    if (eventType == 2027) { <%--Request has been created.--%>
                        r = confirm("Continue deleting request for " + PONUM + "? Deletion cannot be undone.");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestLoader, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 2030 || eventType == 13 || eventType == 15) { <%--Request has been updated.--%>
                        r = confirm(assigneeName + " has started the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestLoader, onFail_deleteRequest);
                        }
                    }
                    else if (eventType == 2031 || eventType == 14 || eventType == 16) { <%--Request has been completed.--%>
                        r = confirm(assigneeName + " has completed the request at " + date + ". Would you like to continue deleting this request?");
                        if (r == true) {
                            PageMethods.deleteRequest(reqID, MSID, onSuccess_deleteRequestLoader, onFail_deleteRequest);
                        }
                    }
                }
                else if (updateType == 'update') {
                    if (eventType == 2027) {<%--Request has been created.--%>
                        $("#loadergrid").data("data-RequestStatus", 'created');
                    }
                    else if (eventType == 2030 || eventType == 13 || eventType == 15) { <%--Request has been updated.--%>
                        alert("You can no longer edit this request because " + assigneeName + " has started it " + date + ".");
                        $("#loadergrid").data("data-RequestStatus", 'started');
                    }
                    else if (eventType == 2031 || eventType == 14 || eventType == 16) { <%--Request has been completed.--%>
                        alert("You can no longer edit this request because " + assigneeName + " has completed it " + date + ".");
                        $("#loadergrid").data("data-RequestStatus", 'completed');
                    }
                }
            }
            else {
                <%-- the query for this doesnt exclude request creation. Thus if there is no value, the request must have been deleted --%>
                alert("The request you are attempting to update has been deleted or has been completed. Please refresh the page to get the current status of all request.");
            }
        }
        function onFail_checkStatusOfLoaderRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkStatusOfLoaderRequest");
        }
        function onSuccess_CreateRequestYardMule(value, ctx, methodName) {
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridDataReload, onFail_getYardMuleRequestsGridData);
        }
        function onSuccess_CreateRequestLoader(value, ctx, methodName) {
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridDataReload, onFail_getLoaderRequestsGridData);
        }
        function onFail_CreateRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_CreateRequest");
        }

        function onSuccess_CheckIfSpotIsAvailableWAlert(value, ctx, methodName) {
            if (value != 0) {
                alert("The spot chosen is currently reserved or is occupied. Please modify or proceed with caution.");
                $("#yardmulegrid").data("data-invalidSpot", true);
                return false;
            }
            else if (value == 0) {
                $("#yardmulegrid").data("data-invalidSpot", false);
            }
        }

        function onSuccess_checkIfRequestTypeExists(value, ctx, methodName) {
            if (value != 0) {
              //  alert("Cannot create new request because there is already an existing request open. Please modify that instead.")
                $("#loadergrid").data("data-invalidRequest", true);
            }
            else { <%-- valid spot --%>
                $("#loadergrid").data("data-invalidRequest", false);
            }
        }

        function onFail_checkIfRequestTypeExists(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkIfRequestTypeExists");
        }


        function onSuccess_CheckIfSpotIsAvailableWConfirm(value, ctx, methodName) {
            if (value != 0) {
                alert("Cannot update. The spot is currently reserved or is occupied. Please modify or proceed with caution.");
                $("#yardmulegrid").data("data-invalidSpot", true);
                return false;
            }
            else { <%-- valid spot --%>
                var row = ctx.owner.grid.findRecordByKey(ctx.rowID);
                $("#yardmulegrid").data("data-invalidSpot", false);
                var assignedYM = null;
                if (!checkNullOrUndefined(ctx.values.YM) == true) {
                    assignedYM = ctx.values.YM;
                }

                PageMethods.updateRequest(row.REQID, ctx.values.TASK, assignedYM, ctx.values.NEWSPOT, row.REQTYPEID, onSuccess_updateRequestYardMule, onFail_updateRequest);//, DUE.toUTCString()
            }

        }

        function onFail_CheckIfSpotIsAvailable(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_CheckIfSpotIsAvailable");
        }

        function onSuccess_deleteRequestYardmule(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridDataReload, onFail_getYardMuleRequestsGridData);
        }

        function onSuccess_deleteRequestLoader(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridDataReload, onFail_getLoaderRequestsGridData);
        }
        function onFail_deleteRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_deleteRequest");
        }

        function onSuccess_updateRequestYardMule(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridDataReload, onFail_getYardMuleRequestsGridData);
        }

        function onSuccess_updateRequestLoader(value, ctx, methodName) {
            <%-- reload grid --%>
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridDataReload, onFail_getLoaderRequestsGridData);
        }

        function onFail_updateRequest(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_updateRequest");
        }

        function onSuccess_getYardMules(value, ctx, methodName) {
            GLOBAL_YARDMULE_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                var fullname = value[i][2] + " " + value[i][3];
                GLOBAL_YARDMULE_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": fullname };
            }
            PageMethods.getLoaders(onSuccess_getLoaders, onFail_getLoaders);
        }
        function onFail_getYardMules(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getYardMules");
        }



        function onSuccess_getLoaders(value, ctx, methodName) {
            GLOBAL_LOADER_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                var fullname = value[i][2] + " " + value[i][3];
                GLOBAL_LOADER_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": fullname };
            }
            PageMethods.getCurrentAvailableTrailers(onSuccess_getCurrentAvailableTrailers, onFail_getCurrentAvailableTrailers);

        }

        function onFail_getLoaders(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getLoaders");
        }

        function onSuccess_getCurrentAvailableTrailers(value, ctx, methodName) {
            GLOBAL_AVAILABLE_TRAILERS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_AVAILABLE_TRAILERS[i] = { "MSID": value[i][0], "VALUE": value[i][1], "TEXT": value[i][1] };
            }
            PageMethods.getRequestPersonTypes(onSuccess_getRequestPersonTypes, onFail_getRequestPersonTypes);

        }

        function onFail_getCurrentAvailableTrailers(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getCurrentAvailableTrailers");
        }


        function onSuccess_getRequestPersonTypes(value, ctx, methodName) {
            GLOBAL_PERSON_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_PERSON_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
            }
            PageMethods.getRequestTypes(null, onSuccess_getRequestTypes, onFail_getRequestTypes);

        }

        function onFail_getRequestPersonTypes(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getRequestPersonTypes");
        }



        function onSuccess_getRequestTypes(value, ctx, methodName) {
            GLOBAL_REQUEST_OPTIONS.length = 0;
            GLOBAL_REQUEST_OPTIONS_FORMATTER.length = 0;

            for (i = 0; i < value.length; i++) {
                GLOBAL_REQUEST_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
                GLOBAL_REQUEST_OPTIONS_FORMATTER[i] = { "ID": value[i][0], "LABEL": value[i][1] };

            }
            var requestpersontype = 2;
            PageMethods.getRequestTypes(requestpersontype, onSuccess_getRequestTypesYardmule, onFail_getRequestTypes);

        }

        function onSuccess_getRequestTypesYardmule(value, ctx, methodName) {
            GLOBAL_REQUEST_YM_OPTIONS.length = 0;

            for (i = 0; i < value.length; i++) {
                GLOBAL_REQUEST_YM_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            var requestpersontype = 1;
            PageMethods.getRequestTypes(requestpersontype, onSuccess_getRequestTypesLoaders, onFail_getRequestTypes);

        }
        function onSuccess_getRequestTypesLoaders(value, ctx, methodName) {
            GLOBAL_REQUEST_LOADER_OPTIONS.length = 0;

            for (i = 0; i < value.length; i++) {
                GLOBAL_REQUEST_LOADER_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }

            PageMethods.GetSpots(onSuccess_GetSpots, onFail_GetSpots);

        }

        function onFail_getRequestTypes(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getRequestTypes");
        }

        function onSuccess_GetSpots(value, ctx, methodName) {
            GLOBAL_SPOT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_SPOT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
                GLOBAL_SPOT_OPTIONS_FORMATTER[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            GLOBAL_SPOT_OPTIONS_FORMATTER.unshift({ "ID": null, "LABEL": "(NONE)" });
            PageMethods.GetAvailablePONumberForYardmuleRequests(onSuccess_GetAvailablePONumberForYardmuleRequests, onFail_GetAvailablePONumberForYardmuleRequests);
        }

        function onFail_GetSpots(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_GetSpots");
        }

        function onSuccess_GetSpotsByType(value, ctx, methodName) {
            GLOBAL_SPOT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_SPOT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            $("#cboxYMNewSpot").igCombo("option", "dataSource", GLOBAL_SPOT_OPTIONS);
            $("#cboxYMNewSpot").igCombo("dataBind");

            if (ctx) {
                $("#cboxYMNewSpot").igCombo("value", ctx);
            }
        }

        function onFail_GetSpotsByType(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_GetSpotsByType");
        }
        function onSuccess_GetAvailablePONumberForYardmuleRequests(value, ctx, methodName) {
            GLOBAL_YARDMULE_PO_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_YARDMULE_PO_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1], "TRUCKTYPE": value[i][2] };
            }
            PageMethods.GetAvailablePONumberForLoaderRequests(onSuccess_GetAvailablePONumberForLoaderRequests, onFail_GetAvailablePONumberForLoaderRequests);
        }
        function onFail_GetAvailablePONumberForYardmuleRequests(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_GetAvailablePONumberForYardmuleRequests");
        }
        function onSuccess_GetAvailablePONumberForLoaderRequests(value, ctx, methodName) {
            GLOBAL_LOADER_PO_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_LOADER_PO_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1], "TRUCKTYPE": value[i][2] };
            }
            PageMethods.getLoaderRequestsGridData(onSuccess_getLoaderRequestsGridData, onFail_getLoaderRequestsGridData);
        }

        function onFail_GetAvailablePONumberForLoaderRequests(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_GetAvailablePONumberForYardmuleRequests");
        }
        function onSuccess_getLoaderRequestsGridData(value, ctx, methodName) {
            GLOBAL_LOADER_DATA.length = 0;
            for (i = 0; i < value.length; i++) {
                var isOpenInCMS;
                var MSID;
                var strDUETime = "";
                var trailNumber;
                var POandTrailer;

                if (value[i][14]) {
                    strDUETime = ("00" + value[i][14].getHours()).slice(-2) + ":" + ("00" + value[i][14].getMinutes()).slice(-2);
                }

                if (value[i][0] == -1) {
                    isOpenInCMS = formatValueToValueOrNA(value[i][16]);
                    MSID = GLOBAL_MSIDForRequestWithOutMSID;
                    PO = formatNegativeOneMSIDToNA(value[i][1]);
                    POandTrailer = GLOBAL_MSIDForRequestWithOutMSID;
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(value[i][16]);
                    MSID = value[i][0];
                    PO = value[i][1];

                    if (checkNullOrUndefined(value[i][12])) {
                        trailNum = "";
                        POandTrailer = PO;
                    }
                    else {
                        trailNum = value[i][12].toString();
                        POandTrailer = PO + ' - ' + trailNum;
                    }
                }

                GLOBAL_LOADER_DATA[i] =
                {
                    "MSID": MSID, "MSIDTEXT": value[i][0], "PO": PO, "REQID": value[i][2], "TASK": value[i][3], "LOADER": value[i][4], "LOADERID": value[i][4], "REQUESTER": value[i][5],
                    "COMMENTS": value[i][6], "NEWSPOT": value[i][7], "NEWSPOTID": value[i][7], "SPOT": value[i][8], "SPOTID": value[i][8], "TIMEASSIGNED": value[i][9], "TSTART": value[i][10],
                    "TEND": value[i][11], "TRAILNUM": trailNumber, "REQTYPEID": value[i][13], "DUE": value[i][14], "DUEDATE": value[i][14],
                    "DUETIME": strDUETime, "REJECT": value[i][15], "isOpenInCMS": isOpenInCMS, "CURRENTSPOTID": value[i][17], "CURRENTSPOT": value[i][17], //, "PRODUCT": value[i][18]
                    "PRODCOUNT": value[i][18], "PRODID": value[i][19], "PRODDETAIL": value[i][20], "POANDTRAILERNUM": POandTrailer
                };
            }

            <%--Call Function to retrieve yard mule grid data--%>
            PageMethods.getYardMuleRequestsGridData(onSuccess_getYardMuleRequestsGridData, onFail_getYardMuleRequestsGridData);
        }
        function onSuccess_getLoaderRequestsGridDataReload(value, ctx, methodName) {
            var MSID = $("#loadergrid").data("data-MSID");
            if (MSID > 0) {
                //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
            }
            else {
                $("#tableLog").empty();
                $("#cboxLogTruckList").igCombo("value", null);
            }
            $("#loadergrid").data("data-MSID", "");
            GLOBAL_LOADER_DATA.length = 0;

            for (i = 0; i < value.length; i++) {
                var isOpenInCMS;
                var strDUETime = "";
                var trailNumber;
                var POandTrailer;
                if (value[i][14]) {
                    strDUETime = ("00" + value[i][14].getHours()).slice(-2) + ":" + ("00" + value[i][14].getMinutes()).slice(-2);
                }
                if (value[i][0] == -1) {
                    isOpenInCMS = formatValueToValueOrNA(value[i][16]);
                    MSID = GLOBAL_MSIDForRequestWithOutMSID;
                    PO = formatNegativeOneMSIDToNA(value[i][1]);
                    POandTrailer = GLOBAL_MSIDForRequestWithOutMSID;
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(value[i][16]);
                    MSID = value[i][0];
                    PO = value[i][1];

                    if (checkNullOrUndefined(value[i][12])) {
                        trailNum = "";
                        POandTrailer = PO;
                    }
                    else {
                        trailNum = value[i][12].toString();
                        POandTrailer = PO + ' - ' + trailNum;
                    }
                }

                GLOBAL_LOADER_DATA[i] =
                {
                    "MSID": MSID, "MSIDTEXT": value[i][0], "PO": PO, "REQID": value[i][2], "TASK": value[i][3], "LOADER": value[i][4], "LOADERID": value[i][4], "REQUESTER": value[i][5],
                    "COMMENTS": value[i][6], "NEWSPOT": value[i][7], "NEWSPOTID": value[i][7], "SPOT": value[i][8], "SPOTID": value[i][8], "TIMEASSIGNED": value[i][9], "TSTART": value[i][10],
                    "TEND": value[i][11], "TRAILNUM": trailNumber, "REQTYPEID": value[i][13], "DUE": value[i][14], "DUEDATE": value[i][14],
                    "DUETIME": strDUETime, "REJECT": value[i][15], "isOpenInCMS": isOpenInCMS, "CURRENTSPOTID": value[i][17], "CURRENTSPOT": value[i][17], //, "PRODUCT": value[i][18]
                    "PRODCOUNT": value[i][18], "PRODID": value[i][19], "PRODDETAIL": value[i][20], "POANDTRAILERNUM": POandTrailer
                };
            }
            $("#loadergrid").igGrid("option", "dataSource", GLOBAL_LOADER_DATA);
            $("#loadergrid").igGrid("dataBind");
        }

        function onFail_getLoaderRequestsGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getLoaderRequestsGridData");
        }

        function onSuccess_checkIfSpotChangeRequestExist(value, ctx, methodName) {
            if (value != 0) {
              //  alert("This PO has a move request that is currently not complete. Please modify the orginal request");
                $("#yardmulegrid").data("data-existingSpot", true);
            }
            else { $("#yardmulegrid").data("data-existingSpot", false); }
        }
        function onSuccess_checkIfSpotChangeRequestExist_OnEdit(value, ctx, methodName) {
            if (value != 0) {
              //  alert("This PO has a move request that is currently not complete. Please modify the orginal request");
                $("#yardmulegrid").data("data-existingSpot", true);
            }
            else { $("#yardmulegrid").data("data-existingSpot", false); }
        }

        function onFail_checkIfSpotChangeRequestExist(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_checkIfSpotChangeRequestExist");
        }

        function setYMGrid(value) {
            for (i = 0; i < value.length; i++) {
                var strDUETime = "";
                if (value[i]["RequestDueDateTime"]) {
                    strDUETime = ("00" + value[i]["RequestDueDateTime"].getHours()).slice(-2) + ":" + ("00" + value[i]["RequestDueDateTime"].getMinutes()).slice(-2);
                }

                var isOpenInCMS;
                var MSID;
                var PO;
                var POandTrailer;
                var trailNum;

                if (value[i][0] == -1) {
                    isOpenInCMS = formatNegativeOneMSIDToNA(value[i]["isOpenInCMS"]);
                    MSID = formatNegativeOneMSIDToNA(value[i]["MSID"]);
                    PO = formatNegativeOneMSIDToNA(value[i]["PONumber"]);
                    POandTrailer = GLOBAL_MSIDForRequestWithOutMSID;
                }
                else {
                    isOpenInCMS = formatBoolAsYesOrNO(value[i]["isOpenInCMS"]);
                    MSID = value[i]["MSID"];
                    PO = value[i]["PONumber"];

                    if (checkNullOrUndefined(value[i]["TrailerNumber"])) {
                        trailNum = "";
                        POandTrailer = PO;
                    }
                    else {
                        trailNum = value[i]["TrailerNumber"].toString();
                        POandTrailer = PO + ' - ' + trailNum;
                    }
                }

                 var strSpotETATime = ("00" + value[i]["SpotReserveTime"].getHours()).slice(-2) + ":" + ("00" + value[i]["SpotReserveTime"].getMinutes()).slice(-2);
                GLOBAL_YARDMULE_DATA[i] = {
                    "MSID": value[i]["MSID"], "MSIDTEXT": MSID, "PO": PO, "REQID": value[i]["RequestID"], "TASK": value[i]["Task"], "YM": value[i]["Assignee"],  "REQUESTER": value[i]["Requester"], "YMID": value[i]["Assignee"],
                    "COMMENTS": value[i]["Comment"], "NEWSPOT": value[i]["NewSpotID"], "NEWSPOTID": value[i]["NewSpotID"], "SPOT": value[i]["AssignedDockSpot"], "SPOTID": value[i]["AssignedDockSpot"], "TIMEASSIGNED": value[i]["TimeRequestSent"],
                    "TSTART": value[i]["TimeRequestStart"], "TEND": value[i]["TimeRequestEnd"], "TRAILNUM": trailNum, "REQTYPEID": value[i]["RequestTypeID"],
                    "DUE": value[i]["RequestDueDateTime"], "DUEDATE": value[i]["RequestDueDateTime"], "DUETIME": strDUETime, "TRUCKTYPE": value[i]["TruckType"],
                    "REJECT": value[i]["isRejected"], "isOpenInCMS": isOpenInCMS, "CURRENTSPOTID": value[i]["currentDockSpotID"], //"PRODUCT": products,
                    "CURRENTSPOT": value[i]["CurrentSpot"], "PRODCOUNT": value[i]["ProdCount"], "PRODID": value[i]["topProdID"], "PRODDETAIL": value[i]["ProductName_CMS"],
                    "SPOTRESERVETIME": value[i]["SpotReserveTime"], "SPOTETADATE": value[i]["SpotReserveTime"],"SPOTETATIME": strSpotETATime, "POANDTRAILERNUM": POandTrailer
                };
                
            }

        }


        function onSuccess_getYardMuleRequestsGridData(value, ctx, methodName) {
            GLOBAL_YARDMULE_DATA.length = 0;

            setYMGrid(value);
            PageMethods.getCompletedRequestData(onSuccess_getCompletedRequestData, onFail_getCompletedRequestData);
        }

        <%--Needs same data as onSuccess_getYardMuleRequestsGridData--%>
        function onSuccess_getYardMuleRequestsGridDataReload(value, ctx, methodName) {
            var MSID = $("#yardmulegrid").data("data-MSID");
            if (MSID > 0) {
               // PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
            }
            else {
                $("#tableLog").empty();
                $("#cboxLogTruckList").igCombo("value", null);
            }

            $("#yardmulegrid").data("data-MSID", "");
            GLOBAL_YARDMULE_DATA.length = 0;
            setYMGrid(value);

            $("#yardmulegrid").igGrid("option", "dataSource", GLOBAL_YARDMULE_DATA);
            $("#yardmulegrid").igGrid("dataBind");
        }


        function onFail_getYardMuleRequestsGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getYardMuleRequestsGridData");
        }


        function onSuccess_getDataForAddNewRowForYM(value, ctx, methodName) {
            var MSID = $("#yardmulegrid").data("data-MSID");
            $("#cboxYMTrailerNum").igCombo("value", null);
            var defaultSpot = null;
            var trailerValue = null;
            if (value.length > 0) {
                if (value[0][0]) {

                    trailerValue = returnItemFromArray(GLOBAL_AVAILABLE_TRAILERS, "TEXT", value[0][0], "VALUE");
                    if (trailerValue) {
                        $("#cboxYMTrailerNum").igCombo("value", trailerValue);
                    }
                }

                if (value[0][1]) {<%--assigned spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(9)").text(value[0][1]); <%-- spot number --%>
                    defaultSpot = value[0][2];
                }
                if (value[0][9]) {<%--current spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(value[0][9]); <%-- spot number --%>
                    defaultSpot = value[0][7];
                }
            }
            if (checkNullOrUndefined(trailerValue)) {
                trailerValue = returnItemFromArray(GLOBAL_AVAILABLE_TRAILERS, "MSID", -1, "VALUE");
                $("#cboxYMTrailerNum").igCombo("value", trailerValue);
            }
            PageMethods.GetSpotsByType(MSID, onSuccess_GetSpotsByType, onFail_GetSpotsByType, defaultSpot);
        }
        function getColumnIndexByKeyForYM(columnKey) {
            var columns = $("#yardmulegrid").igGrid("option", "columns");
            var columnIndex = 0;
            for (var i = 0; i < columns.length; i++) {
                if (columns[i].hidden)
                    continue;
                if (columns[i].key === columnKey) {
                    return columnIndex;
                }
                columnIndex++;
            }
            return -1;
        }
        function onSuccess_getDataForAddNewRowUsingTrailerNum(value, ctx, methodName) {
            if (value.length) {
                var defaultSpot = null;
                if (value[0][1]) {<%--assigned spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(9)").text(value[0][1]); <%-- spot number --%>
                    defaultSpot = value[0][2];
                }
                if (value[0][9]) {<%--current spot--%>
                    $("#yardmulegrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(10)").text(value[0][9]); <%-- spot number --%>
                    defaultSpot = value[0][7];
                }
                if (!checkNullOrUndefined(value[0][3])) {
                    //$("#cboxYMMSID").igCombo("value", value[0][3]);
                    var editor = $("#yardmulegrid").igGridUpdating("editorForKey", "MSID");
                    //$(editor).igEditor("value", "");
                    $(editor).igEditor("value", value[0][3]);
                    $("#yardmulegrid").data("data-MSID", value[0][3]);

                    //$('#yardmulegrid').igGridSelection('selectCell', -1, 3);
                    //$('#yardmulegrid').igGridSelection('selectCell', -1, 4);
                    PageMethods.GetSpotsByType(value[0][3], onSuccess_GetSpotsByType, onFail_GetSpotsByType, defaultSpot);
                }
                else {
                    $("#cboxYMMSID").igCombo("value", -1);
                    $("#yardmulegrid").data("data-MSID", -1);
                    PageMethods.GetSpotsByType(-1, onSuccess_GetSpotsByType, onFail_GetSpotsByType, defaultSpot);
                }

            }
            else {
                $("#cboxYMMSID").igCombo("value", -1);
                $("#yardmulegrid").data("data-MSID", -1);
                PageMethods.GetSpotsByType(-1, onSuccess_GetSpotsByType, onFail_GetSpotsByType, defaultSpot);
            }
        }

        function onFail_getDataForAddNewRowUsingTrailerNum(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getDataForAddNewRowUsingTrailerNum");

        }

        function onSuccess_getDataForAddNewRowForLoader(value, ctx, methodName) {
            if (value.length) {
                if (value[0][1]) {<%--assigned spot--%>
                    $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(6)").text(value[0][1]); <%-- spot number --%>
                }
                if (value[0][9]) {<%--current spot--%>
                    $("#loadergrid tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(7)").text(value[0][9]);
                }

                <%--Load Type--%>
                if (value[0][5]) {
                    if (value[0][5] == "LOADIN") {<%--load--%>
                        $("#cboxReqTypes").igCombo("value", 1);
                    }
                    else {<%--unload--%>
                        $("#cboxReqTypes").igCombo("value", 2);
                    }
                }

                <%--if not drop trailer--%>
                if (checkNullOrUndefined(value[0][4]) == true || value[0][4] == false) {
                    var today = new Date();
                    $("#dpLoaderDUEDATE").igDatePicker("value", today);
                    var dTime = new Date(value[1]);
                    var dueTime = ("00" + dTime.getHours()).slice(-2) + ":" + ("00" + dTime.getMinutes()).slice(-2);
                    $("#dpLoaderDueTime").igDatePicker("value", dueTime);
                }
            }
            else {
                $("#cboxReqTypes").igCombo("value", 3);
            }
        }

        function onFail_getDataForAddNewRow(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getDataForAddNewRow");
        }


        function onSuccess_GetTimeslotsData(value, ctx, methodName) {
            var check = value;
            var colCount = value[0] + 1; <%--+1 for time column--%>
            var headerData = value[1];
            headerData.splice(0, 0, [-1, "Time"]); <%--add time column header--%>
            var data = value[2];
            var schedGridData = [];

            for (i = 0; i < data.length; i++) {
                schedGridData[i] = {
                    "SPOTID": data[i][0], "FROMTIME": data[i][1], "TOTIME": data[i][2], "ISOPEN": data[i][3], "TRUCKTYPE": data[i][4],
                    "ISDISABLED": data[i][5], "DAYOFWEEK": data[i][6], "ISAPPT": data[i][7], "HRSBLOCK": data[i][8], "PONUM": data[i][9]
                };
            }

            var newHeader = createScheduleGridHeader(colCount, headerData, schedGridData);
            var dvTableHeader = $("#dwScheduleTableHeader");
            dvTableHeader.html("");
            dvTableHeader.append(newHeader);

            var newtable = createScheduleGrid(colCount, headerData, schedGridData, false);
            var dvTable = $("#dwScheduleTable");
            dvTable.html("");
            dvTable.append(newtable);

            <%--setup for highlighting selected--%>
            var selSpot = $("#cboxYMNewSpot").igCombo("value");
            if (!selSpot) {
                selSpot = -999; <%--set to -999 for no spot column--%>
            }
            var newTime = $("#txtDUETIME").igEditor("option", "value");
            $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').removeClass(); <%--remove all classes on cell--%>
            $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').addClass("cell_Selected").addClass("cell_Available")
            var MSID = $("#yardmulegrid").data("data-MSID"); <%--MSID FROM editted grid--%>
            var selDateText = $("#dpETADATE").igEditor("text");
            var po = formatYardmulePOCombo(MSID);
            $("#dwSchedulePOLabel").text(" PO: " + po + " DATE: " + selDateText);


            $(dwSchedule).igDialog("open");
        }

        function onFail_GetTimeslotsData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_GetTimeslotsData");
        }

        function onSuccess_getCompletedRequestData(gridData, ctx, methodName) {
            if (gridData) {
                var requester = "";
                var assignee = "";
                for (i = 0; i < gridData.length; i++) {
                    var isOpenInCMS;
                    requester = gridData[i][4] + " " + gridData[i][5];
                    assignee = gridData[i][6] + " " + gridData[i][7];
                    isOpenInCMS = formatBoolAsYesOrNO(gridData[i][17]);

                    GLOBAL_COMPLETE_DATA[i] = {
                        "MSID": gridData[i][0], "PO": gridData[i][1], "REQID": gridData[i][2], "TASK": gridData[i][3], "REQUESTER": requester, "ASSIGNEE": assignee,
                        "TIMEASSIGNED": gridData[i][8], "TSTART": gridData[i][9], "TEND": gridData[i][10], "COMMENTS": gridData[i][11], "NEWSPOT": gridData[i][12],
                        "TRAILNUM": gridData[i][13], "DUETIME": gridData[i][14], "REJECT": gridData[i][16], "isOpenInCMS": isOpenInCMS // truck type =  gridData[i][15] not sure why its here but didnt want to remove it
                    };
                }
            }
            <%--Call init grid to setup grids --%>
            init_grid();
        }

        function onFail_getCompletedRequestData(value, ctx, methodName) {
            sendtoErrorPage("Error in dockManager.aspx, onFail_getCompletedRequestData");
        }

        <%-------------------------------------------------------
        Click Handlers
        -------------------------------------------------------%>

        function onclick_ShowYardMule() {
            $("#yardMuleGridWrapper").show();
            $("#btn_ShowYM").hide();
            $("#btn_HideYM").show();
        }
        function onclick_HideYardMule() {
            $("#yardMuleGridWrapper").hide();
            $("#btn_ShowYM").show();
            $("#btn_HideYM").hide();
        }
        function onclick_ShowLoader() {
            $("#loadergridWrapper").show();
            $("#btn_ShowLoader").hide();
            $("#btn_HideLoader").show();
        }
        function onclick_HideLoader() {
            $("#loadergridWrapper").hide();
            $("#btn_ShowLoader").show();
            $("#btn_HideLoader").hide();
        }
        function onclick_ShowComplete() {
            $("#completedGridWrapper").show();
            $("#btn_ShowComplete").hide();
            $("#btn_HideComplete").show();
        }
        function onclick_HideComplete() {
            $("#completedGridWrapper").hide();
            $("#btn_ShowComplete").show();
            $("#btn_HideComplete").hide();
        }

        function onclick_availableCellClick(evt, ui) {
            var spotTime = $(this).data("hour");
            var spotID = $(this).data("spotid");

            var spotName = "";
            if (spotID !== -999) {
                spotName = formatSpotCombo(spotID);
            }
            var timeblock = $(this).data("timeblock");
            if (timeblock) {
                // need the -1 to make timeblock 1 min less ( eg: 10:29 or 10:59 ) for the cell of time adjacent to it (eg: 10:30, 11:00) ; boundary condition
                timeblock = timeblock * 60 -1 <%--convert to min--%>
            }
            else {
                timeblock = 0;
            }

            var splitHr = spotTime.split(":");
            var hr = splitHr[0];
            var min = splitHr[1];

            var cellDate = new Date(1900, 0, 1, hr, min, 0);
            var startHour = ("00" + cellDate.getHours()).slice(-2) + ":" + ("00" + cellDate.getMinutes()).slice(-2);
            var endDate = new Date(cellDate.getTime() + timeblock * 60000);
            var isValidBlock = true;

            <%--iterate from starttime to endtime and get cells within that range and spotid and check for class cell_notAvailable--%>
            while (cellDate <= endDate) {
                var newtime = ("00" + cellDate.getHours()).slice(-2) + ":" + ("00" + cellDate.getMinutes()).slice(-2);
                var isNotAvailable = $('td[data-hour="' + newtime + '"][data-spotID="' + spotID + '"]').hasClass("cell_notAvailable");
                if (isNotAvailable) {
                    isValidBlock = false;
                }
                cellDate = new Date(cellDate.getTime() + 30 * 60000); <%--add 30 min--%>

            }
            if (isValidBlock) {
                var response;
                if (checkNullOrUndefined(spotName)) {

                    response = confirm("Select " + startHour + " for task? ");
                }
                else {

                    response = confirm("Select " + startHour + " at spot " + spotName + " for task? ");
                }

                if (response) {

                    var selSpot = $("#cboxYMNewSpot").igCombo("value", spotID);
                    var newTime = $("#txtETATIME").igEditor("option", "value", startHour);

                    $(dwSchedule).igDialog("close");

                }
            }
            else {
                alert("Not a valid time block. Please select a different time.");
            }
        }
        <%-------------------------------------------------------
         Initialize page components
         -------------------------------------------------------%>
        $(function () {
            $(".arrowGridScrollButtons").show();
            $("#btn_ShowYM").hide();
            $("#btn_ShowLoader").hide();
            $("#btn_ShowComplete").hide();

            $("#dwSchedule").igDialog({
                minWidth: "300px",
                minHeight: "300px",
                maxHeight: "75%",
                state: "closed",
                resizable: false,
                modal: true,
                draggable: false,
                showCloseButton: true
            });
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
                { headerText: "CMS Product ID ", key: "CMSPROD", dataType: "string", width: "150px" },
                { headerText: "CMS Product ID", key: "CMSPRODNAME", dataType: "string", width: "150px" },
                { headerText: "QTY", key: "QTY", dataType: "number", width: "150px" },
                { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px" }

                ]
            });

            <%--Start call; will cascade and call other pagemethods--%>
            PageMethods.getYardMules(onSuccess_getYardMules, onFail_getYardMules);

            <%-- Add click handler: --%>
            $(dwSchedule).on("click", "td.cell_Available", onclick_availableCellClick);
            $(dwSchedule).on("click", "td.cell_Available.cell_ScheduledButOverWritable", onclick_availableCellClick);

            <%--set data attributes--%>
            $("#yardmulegrid").data("data-existingSpot", false);
            $("#yardmulegrid").data("data-invalidSpot", false);
            $("#yardmulegrid").data("data-MSID", -1);
            $("#yardmulegrid").data("data-REQID", 0);

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
                     //   PageMethods.GetLogDataByMSID(ui.items[0].data.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ui.items[0].data.MSID);
                    }
                    else if (ui.items.length == 0) {
                        $("#tableLog").empty();
                        $("#cboxLogTruckList").igCombo("value", null);
                    }
                }
            });
            //PageMethods.GetLogList(onSuccess_GetLogList, onFail_GetLogList);

            $(document).delegate("#yardmulegrid", "iggridcellclick", function (evt, ui) {
                if (GLOBAL_ISDIALOG_OPEN === false) {
                    PageMethods.checkStatusOfYMRequest(ui.rowKey, onSuccess_checkStatusOfYMRequest, onFail_checkStatusOfYMRequest, 'update');
                }
                else {
                    GLOBAL_ISDIALOG_OPEN = false;
                }
            });

            $(document).delegate("#loadergrid", "iggridcellclick", function (evt, ui) {
                if (GLOBAL_ISDIALOG_OPEN === false) {
                    PageMethods.checkStatusOfLoaderRequest(ui.rowKey, onSuccess_checkStatusOfLoaderRequest, onFail_checkStatusOfLoaderRequest, 'update');
                }
                else {
                    GLOBAL_ISDIALOG_OPEN = false;
                }
            });
        }); <%-- $(function () {  --%>
        
         $(".logWindow").hide();
    </script>

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="logWindow" style="display: none">
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
    <div id="dwProductDetails">
        <h2><span>PO - Trailer:     <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>

    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideYardMule()" value="Hide Grid" id="btn_HideYM" />
            <input type="button" onclick="    onclick_ShowYardMule()" value="Show Grid" id="btn_ShowYM" /></div>
        <h2>Assign Tasks to Yardmule</h2>
    </div>
    <br />
    <br />
    <div id="yardMuleGridWrapper">
        <table id="yardmulegrid" class="scrollGridClass"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideLoader()" value="Hide Grid" id="btn_HideLoader" />
            <input type="button" onclick="    onclick_ShowLoader()" value="Show Grid" id="btn_ShowLoader" /></div>
        <h2>Assign Trucks to Loader</h2>
    </div>
    <br />
    <br />
    <div id="loadergridWrapper">
        <table id="loadergrid" class="scrollGridClass"></table>
    </div>
    <div>
        <div style="float: right">
            <input type="button" onclick="onclick_HideComplete()" value="Hide Grid" id="btn_HideComplete" />
            <input type="button" onclick="    onclick_ShowComplete()" value="Show Grid" id="btn_ShowComplete" /></div>
        <h2>Completed Loader & Yard Mule Requests</h2>
    </div>
    <br />
    <br />
    <div id="completedGridWrapper">
        <table id="completedGrid" class="scrollGridClass"></table>
    </div>
    <%-- dialog for schedule selection--%>
    <div id="dwSchedule" style="position: relative">
        <div id="dwScheduleDiv1">Click a cell to choose a time and spot for
            <div id="dwSchedulePOLabel"></div>
        </div>
        <div id="dwScheduleTableHeader"></div>
        <div id="dwScheduleTable"></div>
    </div>

</asp:Content>
