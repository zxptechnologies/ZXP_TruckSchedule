<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="inspectionNew.aspx.cs" Inherits="TransportationProject.inspectionNew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Content/InspectionsPageStyle.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Inspections</h2>
    <%--<h3>This page allows you to display or create an inspection for a truck</h3>--%>
    <h3>View, create, edit, and delete inspections for truck orders.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">
        //1= yes, 2=no, 3 = null 
        var GLOBAL_POID = 123;
        var GLOBAL_PO;
        var GLOBAL_INSPECTIONTYPE = "MT";
        var GLOBAL_TRUCK_DATA = [];
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_INSPECTIONGROUP_OPTIONS = [];
        var GLOBAL_INSPECTION_VERSIONS = [];
        var GLOBAL_INSPECTION_RESULTTYPES = [];
        var inspectionActions = {
            START: 1,
            END: 2,
            REOPEN: 3,
            VIEW: 4,
            DELETE: 5,
            CREATE: 6,
            NONE: -1,

        }

        <%--                                                  --%>
        <%-------------------------------------------------------
                                Functions
         -------------------------------------------------------%>
        function onclick_redirectToRejectTruck() {
            var MSID = $("#cboxTruckList").igCombo("value");
            sessionStorage.setItem('MSID', MSID);
            location.href = 'rejectTruck.aspx';
        }

        function openProductDetailDialog(MSID) {
            var PO = $("#gridMissingResults").igGrid("getCellValue", MSID, "PONUM");
            var trailer = $("#gridMissingResults").igGrid("getCellValue", MSID, "TRAILNUM");
            var POTrailer = null;
            if (checkNullOrUndefined(trailer)) {
                POTrailer = PO;
            }
            else {
                POTrailer = PO + " - " + trailer;
            }
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
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_getPODetailsFromMSID");
        }
        function OnClick_AddImage(evt, msid, id) {
            $('#igUploadIMAGE').data("MSID", msid);
            $("#igUploadIMAGE_ibb_fp").click();
        }

        function onSuccess_ImageUpload(id) {
            alert("Image Upload Successful ");
            $("#CameraUpload" + id).val("");
        }

        function onFailure_ImageUpload(id) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFailure_ImageUpload");
            $("#CameraUpload" + id).val("");
        }

        function chooseFile(id) {
            $("#CameraUpload" + id).click();
        }

        Number.prototype.padLeft = function (base, chr) {
            var len = (String(base || 10).length - String(this).length) + 1;
            return len > 0 ? new Array(len).join(chr || '0') + this : this;
        }

        function boolYesNoFormatter(val) {
            if (val) {
                return "YES"
            }
            else {
                return "NO"
            }
        }

            <%-------------------------------------------------------
         Button Click Handlers
         -------------------------------------------------------%>

        function onclick_deleteFile(fid) {
            r = confirm("Continue removing this file from the truck data? This cannot be undone.")
            if (r) {
                var msid = $('#dwFileUpload').data("data-MSID");
                PageMethods.deleteFileDBEntry(fid, "OTHER", msid, onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, fid);
            }
        }
        function OnRadioButtonClick(testID, inspID, result, oldValue) {

            $("#radNA_" + testID.toString()).attr("checked", false);
            $("#radPass_" + testID.toString()).attr("checked", false);
            $("#radFail_" + testID.toString()).attr("checked", false);

            $("#grid").igGridUpdating("setCellValue", testID, "RESULT", result);
            $("#grid").igGrid("cellById", testID, "RESULT").val(result);

            if (GLOBAL_INSPECTION_RESULTTYPES.PASS.ResultValue === result) { <%--pass--%>
                    $("#grid").igGridUpdating("setCellValue", testID, "NA", false);
                    $("#grid").igGrid("cellById", testID, "NA").val(false);

                    $("#grid").igGridUpdating("setCellValue", testID, "PASS", true);
                    $("#grid").igGrid("cellById", testID, "PASS").val(true);

                    $("#grid").igGridUpdating("setCellValue", testID, "FAIL", false);
                    $("#grid").igGrid("cellById", testID, "FAIL").val(false);

                }
                else if (GLOBAL_INSPECTION_RESULTTYPES.FAIL.ResultValue === result) {<%--fail--%>
                    $("#grid").igGridUpdating("setCellValue", testID, "NA", false);
                    $("#grid").igGrid("cellById", testID, "NA").val(false);

                    $("#grid").igGridUpdating("setCellValue", testID, "PASS", false);
                    $("#grid").igGrid("cellById", testID, "PASS").val(false);

                    $("#grid").igGridUpdating("setCellValue", testID, "FAIL", true);
                    $("#grid").igGrid("cellById", testID, "FAIL").val(true);

                }
                else if (GLOBAL_INSPECTION_RESULTTYPES.NA.ResultValue === result) {<%--not applicable--%>
                    $("#grid").igGridUpdating("setCellValue", testID, "NA", true);
                    $("#grid").igGrid("cellById", testID, "NA").val(true);

                    $("#grid").igGridUpdating("setCellValue", testID, "PASS", false);
                    $("#grid").igGrid("cellById", testID, "PASS").val(false);

                    $("#grid").igGridUpdating("setCellValue", testID, "FAIL", false);
                    $("#grid").igGrid("cellById", testID, "FAIL").val(false);
                }
            $("#grid").igGrid("commit");

            if (!checkNullOrUndefined(result)) {
                var resultData = [];
                resultData[0] = testID;
                resultData[1] = result;
                var MSID = $("#cboxTruckList").igCombo("value");
                PageMethods.setInspectionResult(MSID, inspID, testID, result, null, onSuccess_setInspectionResult, onFail_setInspectionResult, resultData);
            }
        }
        /***************************************************************************************
        //Functions for hiding specific divs
        *****************************************************************************************/
        function show_dvSectionViewTruck_Details() {
            $("#dvSectionViewTruck_Details").show();
            $("#btn_hide_dvSectionViewTruck_Details").show();
            $("#btn_show_dvSectionViewTruck_Details").hide();
                <%-- add code as needed--%>
            }
        function hide_dvSectionViewTruck_Details() {
            $("#dvSectionViewTruck_Details").hide();
            $("#btn_show_dvSectionViewTruck_Details").show();
            $("#btn_hide_dvSectionViewTruck_Details").hide();
                <%-- add code as needed--%>
            }
        function show_dvSectionUpdateLocationStatus_Details() {
            $("#dvSectionUpdateLocationStatus_Details").show();
            $("#btn_hide_dvSectionUpdateLocationStatus_Details").show();
            $("#btn_show_dvSectionUpdateLocationStatus_Details").hide();
                <%-- add code as needed--%>
        }
        function hide_dvSectionUpdateLocationStatus_Details() {
            $("#dvSectionUpdateLocationStatus_Details").hide();
            $("#btn_hide_dvSectionUpdateLocationStatus_Details").hide();
            $("#btn_show_dvSectionUpdateLocationStatus_Details").show();
                <%-- add code as needed--%>
            }
        function show_dvSectionViewInspectionList_Details() {
            $("#btn_show_dvSectionViewInspectionList_Details").hide();
            $("#btn_hide_dvSectionViewInspectionList_Details").show();
            $("#dvSectionViewInspectionList_Details").show();
                <%-- add code as needed--%>
        }
        function hide_dvSectionViewInspectionList_Details() {
            $("#btn_show_dvSectionViewInspectionList_Details").show();
            $("#btn_hide_dvSectionViewInspectionList_Details").hide();
            $("#dvSectionViewInspectionList_Details").hide();
                <%-- add code as needed--%>
        }


        /***************************************************************************************
        //Functions for hiding elements at page load() 
        *****************************************************************************************/
        function hideAtInit() {
            showMissingResults();
            disableInspectionTests();
            $("#dvResults").hide();
            hideAllSections();
        }

        function hideAllSections() {
            hide_dvSectionViewTruck_Details();
            hide_dvSectionUpdateLocationStatus_Details();
            hide_dvSectionViewInspectionList_Details();
        }
        function showAllSections() {
            show_dvSectionViewTruck_Details();
            show_dvSectionUpdateLocationStatus_Details();
            show_dvSectionViewInspectionList_Details();
        }

        function showMissingResults() {
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
            $("#btn_hideMissingResults").show();
            $("#btn_showMissingResults").hide();
            $("#dvMissingResults").show();
        }

        function hideMissingResults() {
            $("#btn_hideMissingResults").hide();
            $("#btn_showMissingResults").show();
            $("#dvMissingResults").hide();
        }
        function disableInspectionTests() {
            $("#grid").igGridUpdating("option", "editMode", "none");
            $("input:radio").attr("disabled", true);
        }
        function enableInspectionTests() {
            $("#grid").igGridUpdating("option", "editMode", "row");
            $("input:radio").attr("disabled", false);
        }

        function viewOnlyMode(shouldHideButtons) {
            disableInspectionTests();
            $("#btnUpdateInspectionComment").hide();
            $("#txtInspectionComment").attr("disabled", true);
            $("#txtInspectionComment").attr("readonly", true);
            $("#msgReadOnly").show();

            if (shouldHideButtons) {
                $("#btnInspectionStart").hide();
                $("#btnInspectionEnd").hide();
                $("#btnInspectionReopen").hide();
                $("#btnDeleteInspection").hide();
            }
        }

         <%-------------------------------------------------------
        Button Click Handlers
        -------------------------------------------------------%>

        function clearTruckScheduleGridFilter(evt, ui) {
            $("#gridMissingResults").igGridFiltering("filter", []);
        }
        function todayFilterForGridMissingResults() {
            var today = new Date();

            $("#gridMissingResults").igGridFiltering("filter",
                [{ fieldName: "ETA", expr: today, cond: "today" }],
                true);
        }
        function onclick_ShowAllTrucks(evt, ui) {
            clearTruckScheduleGridFilter()
        }
        function onclick_ShowTodayOnly(evt, ui) {

            clearTruckScheduleGridFilter();
            todayFilterForGridMissingResults();
        }
        function onclick_UpdateComment() {
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionID = $("#gridOfInspectionVersions").data("MSInspectionID");
            if (msidItems && inspectionID) {
                var MSID = msidItems[0].data.MSID;

                var placeholdertext = $("#txtInspectionComment").attr("placeholder");
                var comment = $("#txtInspectionComment").val().replace(placeholdertext, "");
                PageMethods.updateInspectionComment(MSID, inspectionID, comment, onSuccess_updateInspectionComment, onFail_updateInspectionComment)
            }
        }
        function onclick_UpdateLocation() {
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var locstatItems = $("#cboxLocationStatus").igCombo("selectedItems");
            var dockSpot = $("#cboxDockSpots").igCombo("selectedItems");
            if (msidItems && locstatItems) {
                var MSID = msidItems[0].data.MSID;
                var locstat = locstatItems[0].data.LOCSTAT;
                var dockSpotID = null;
                if (!checkNullOrUndefined(dockSpot)) {
                    dockSpotID = dockSpot[0].data.SPOTID;
                }
                PageMethods.updateLocation(MSID, locstat, dockSpotID, onSuccess_updateLocation, onFail_updateLocation, MSID);
            }
        }
        function onclick_CreateNewInspectionVersion() {
            //TODO:  get MSID and MSInspDetailID and call pagemethod to create new inspection version
            $("#msgResults").text("");
            $("#msgErrorCreateNewVersion").text("");
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var MSID = msidItems[0].data.MSID;
            var MSInspDetailID = $("#gridOfInspectionVersions").data("MSInspectionDetailID");

            var contextParam = [];
            contextParam["MSInspID"] = "";
            contextParam["MSInsListID"] = "";
            contextParam["MSID"] = MSID;
            contextParam["iAction"] = inspectionActions.CREATE;
            contextParam["MSInspDetailID"] = MSInspDetailID;
            $("#gridOfInspectionVersions").data("ctxData", contextParam);
            PageMethods.createNewInspectionWMsgOut(MSID, MSInspDetailID, onSuccess_createNewInspectionWMsgOut, onFail_createNewInspectionWMsgOut, contextParam);
        }
        function onclick_ViewAllVersionsOfInspection(MSInspDetailID, InspectionHeaderName, Sort) {
            $("#dvInspectionListData_Details").show();
            $("#lblSelectedInspection").text("List Order#: " + Sort.toString() + ", " + InspectionHeaderName);
            $("#gridOfInspectionVersions").data("MSInspectionDetailID", MSInspDetailID);
            $("#msgResults").text("");
            $("#msgErrorCreateNewVersion").text("");
            $("#dvSectionViewInspectionTest").hide();
            PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
        }
        function onclick_createOrViewListAndInspections() {
            $("#lblMsgcreateOrViewListAndInspections").text("");
            $("#lblSelectedList").text("");
            $("#lblSelectedInspection").text("");
            $("#lblSelectedVersion").text("");
            $("#msgErrorCreateNewVersion").text("");
            $("#msgResults").text("");
            $("#dvSectionViewInspectionTest").hide();

            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionListItems = $("#cboxInspectionGroupList").igCombo("selectedItems");
            var productItems = $("#cboxProductInspectionFilter").igCombo("selectedItems");
            var MSInspectionListVersion = $("#cboxInspectionGroupVersionList").igCombo("selectedItems");

            if (msidItems && inspectionListItems && productItems && MSInspectionListVersion) {
                $("#dvInspectionList_InspectionNames").show();
                $("#lblSelectedList").text(inspectionListItems[0].data.INSPECTGROUPNAME);
                var canCreateInspection = checkNullOrUndefined($("#cboxTruckList").data("data-canCreateEditInspection")) ? false: $("#cboxTruckList").data("data-canCreateEditInspection");
                var MSID = msidItems[0].data.MSID;
                var inspectionListID = inspectionListItems[0].data.INSPECTGROUPID;
                var productCMS = productItems[0].data.PRODID
                var inspectionListIDwVersion = MSInspectionListVersion[0].data.INSPECTIONLISTID;
                PageMethods.createOrViewListAndInspections(MSID, inspectionListID, canCreateInspection, productCMS, inspectionListIDwVersion, onSuccess_createOrViewListAndInspections, onFail_createOrViewListAndInspections);
            }
        }

        function onclick_ViewInspection(MSInspID, MSID, MSInsListID, InspectionName, isFailed) {
            if (InspectionName) {
                $("#lblSelectedVersion").text(InspectionName);
            }
            $("#msgResults").text("");
            if (!checkNullOrUndefined(MSInspID) && !checkNullOrUndefined(MSID) && !checkNullOrUndefined(MSInsListID)) {
                $("#gridOfInspectionVersions").data("MSInspectionID", MSInspID);
                var contextParam = [];
                contextParam["MSInspID"] = MSInspID;
                contextParam["MSInsListID"] = MSInsListID;
                contextParam["MSID"] = MSID;
                contextParam["iAction"] = inspectionActions.VIEW;
                contextParam["isFailed"] = isFailed;
                $("#gridOfInspectionVersions").data("ctxData", contextParam);
                PageMethods.canInspectionBeViewed(MSInsListID, MSInspID, MSID, onSuccess_canInspectionBeViewed, onFail_canInspectionBeViewed, contextParam);
            }
            else {
                alert("Error viewing the selected inspection. Please refresh the page and start again.");
            }
        }

        function onclick_StartInspection(MSInspID, MSID, MSInsListID, InspectionName, isFailed) {
            $("#msgResults").text("");
            $("#lblSelectedVersion").text(InspectionName);
            if (!checkNullOrUndefined(MSInspID) && !checkNullOrUndefined(MSID) && !checkNullOrUndefined(MSInsListID)) {
                $("#gridOfInspectionVersions").data("MSInspectionID", MSInspID);
                var contextParam = [];
                contextParam["MSInspID"] = MSInspID;
                contextParam["MSInsListID"] = MSInsListID;
                contextParam["MSID"] = MSID;
                contextParam["iAction"] = inspectionActions.START;
                contextParam["isFailed"] = isFailed;
                $("#gridOfInspectionVersions").data("ctxData", contextParam);
                PageMethods.canInspectionBeStarted(MSInsListID, MSInspID, MSID, onSuccess_canInspectionBeStarted, onFail_canInspectionBeStarted, contextParam)
            }
            else {
                alert("Error starting the selected inspection. Please refresh the page and start again.");
            }
        }

        function onclick_EndInspection(MSInspID, MSID, MSInsListID, InspectionName, isFailed) {
            $("#msgResults").text("");
            $("#lblSelectedInspectlblSelectedVersionion").text(InspectionName);
            if (!checkNullOrUndefined(MSInspID) && !checkNullOrUndefined(MSID) && !checkNullOrUndefined(MSInsListID)) {
                $("#gridOfInspectionVersions").data("MSInspectionID", MSInspID);
                var contextParam = [];
                contextParam["MSInspID"] = MSInspID;
                contextParam["MSInsListID"] = MSInsListID;
                contextParam["MSID"] = MSID;
                contextParam["iAction"] = inspectionActions.END;
                contextParam["isFailed"] = isFailed;
                $("#gridOfInspectionVersions").data("ctxData", contextParam);
                PageMethods.canInspectionBeEnded(MSInsListID, MSInspID, MSID, onSuccess_canInspectionBeEnded, onFail_canInspectionBeEnded, contextParam);
            }
            else {
                alert("Error ending the selected inspection. Please refresh the page and start again.");
            }
        }

        function onclick_ReopenAndUpdateInspection(MSInspID, MSID, MSInsListID, InspectionName, isFailed) {
            $("#msgResults").text("");
            $("#lblSelectedVersion").text(InspectionName);
            if (!checkNullOrUndefined(MSInspID) && !checkNullOrUndefined(MSID) && !checkNullOrUndefined(MSInsListID)) {
                $("#gridOfInspectionVersions").data("MSInspectionID", MSInspID);
                var contextParam = [];
                contextParam["MSInspID"] = MSInspID;
                contextParam["MSInsListID"] = MSInsListID;
                contextParam["MSID"] = MSID;
                contextParam["iAction"] = inspectionActions.REOPEN;
                contextParam["isFailed"] = isFailed;
                $("#gridOfInspectionVersions").data("ctxData", contextParam);
                PageMethods.canInspectionBeReopened(MSInsListID, MSInspID, MSID, onSuccess_canInspectionBeReopened, onFail_canInspectionBeReopened, contextParam);
            }
            else {
                alert("Error reopening the selected inspection. Please refresh the page and start again.");
            }

        }

        function onclick_DeleteInspection(MSInspID, MSID, MSInsListID) {
            $("#msgResults").text("");
            if (!checkNullOrUndefined(MSInspID) && !checkNullOrUndefined(MSID) && !checkNullOrUndefined(MSInsListID)) {
                $("#gridOfInspectionVersions").data("MSInspectionID", MSInspID);
                var contextParam = [];
                contextParam["MSInspID"] = MSInspID;
                contextParam["MSInsListID"] = MSInsListID;
                contextParam["MSID"] = MSID;
                contextParam["iAction"] = inspectionActions.DELETE;
                $("#gridOfInspectionVersions").data("ctxData", contextParam);
                PageMethods.canInspectionBeDeleted(MSInsListID, MSInspID, MSID, onSuccess_canInspectionBeDeleted, onFail_canInspectionBeDeleted, contextParam);
            }
            else {
                alert("Error ending the selected inspection. Please refresh the page and start again.");
            }
        }

        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>

        function onSuccess_getAvailableRunsOfInspection(value, ctx, methodName) {
            var cboxData = [];
            cboxData.length = 0;
            for (i = 0; i < value.length; i++) {
                cboxData[i] = { "VERSIONID": value[i][0], "VERSION": "Ver_" + value[i][1].toString() };
            }
            cboxData.unshift({ "VERSIONID": -1, "VERSION": "(Create New)" })
            $("#cboxVersion").igCombo("option", "dataSource", cboxData);
            $("#cboxVersion").igCombo("dataBind");
        }
        function onFail_getAvailableRunsOfInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_getAvailableRunsOfInspection");
        }

        function onSuccess_getInspectionListVersionsByListID(value, ctx, methodName) {
            var cboxData = [];
            cboxData.length = 0;
            for (i = 0; i < value.length; i++) {
                cboxData[i] = { "INSPECTIONLISTID": value[i][0], "INSPECTVERSION": value[i][1].toString() + "- RUN: " + value[i][2].toString(), "RUNNUMBER": value[i][2] };
            }
            cboxData.unshift({ "INSPECTIONLISTID": -1, "INSPECTVERSION": "(Create New)" })
            $("#cboxInspectionGroupVersionList").igCombo("option", "dataSource", cboxData);
            $("#cboxInspectionGroupVersionList").igCombo("dataBind");
        }
        function onFail_getInspectionListVersionsByListID(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_getInspectionListVersionsByListID");
        }

        function onSuccess_createNewInspectionWMsgOut(value, ctx, methodName) {
            if (!checkNullOrUndefined(value)) {
                var MSInspectionID = value[0];

                if (0 === MSInspectionID) {
                    var msg = value[1];
                    $("#msgErrorCreateNewVersion").text(msg);
                }
                else {
                    var MSID = ctx["MSID"];
                    var MSInspDetailID = ctx["MSInspDetailID"];
                    PageMethods.getInspectionGridData(MSInspectionID, onSuccess_getInspectionGridData, onFail_getInspectionGridData, ctx);
                    PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
                    PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
                    PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                }
            }
        }

        function onFail_createNewInspectionWMsgOut(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_createNewInspectionWMsgOut");
        }

        function onSuccess_canInspectionBeViewed(value, ctx, methodName) {
            if (!checkNullOrUndefined(value)) {
                var canView = value[0];
                var msg = value[1];
                var MSInspID = ctx["MSInspID"];
                var MSID = ctx["MSID"];

                if (canView) {
                    PageMethods.isInspectionClosed(MSInspID, onSuccess_isInspectionClosed, onFail_isInspectionClosed, ctx);
                    PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                    $("#dvSectionViewInspectionTest").show();
                    if (msg) {
                        $("#msgResults").text(msg);
                    }
                }
                else {
                    if (!checkNullOrUndefined(msg)) {
                        alert(msg);
                    }
                }
            }
        }

        function onFail_canInspectionBeViewed(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_canInspectionBeViewed");
        }

        function onSuccess_canInspectionBeEnded(value, ctx, methodName) {
            if (!checkNullOrUndefined(value)) {
                var canEnd = value[0];
                var msg = value[1];
                var MSInspID = ctx["MSInspID"];
                var MSID = ctx["MSID"];
                if (canEnd) {
                    PageMethods.endInspectionWrapper(MSID, MSInspID, onSuccess_endInspectionWrapper, onFail_endInspectionWrapper, ctx);
                    $("#dvSectionViewInspectionTest").show();
                    if (msg) {
                        $("#msgResults").text(msg);
                    }
                }
                else {
                    <%--added check--%>
                    if (!checkNullOrUndefined(msg)) {
                        alert(msg);
                    }
                }
            }
        }

        function onFail_canInspectionBeEnded(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_canInspectionBeEnded");
        }

        function onSuccess_canInspectionBeReopened(value, ctx, methodName) {
            if (!checkNullOrUndefined(value)) {
                var canReopen = value[0];
                var msg = value[1];

                if (canReopen) {
                    var MSInspID = ctx["MSInspID"];
                    var MSID = ctx["MSID"];

                    PageMethods.reopenInspection(MSID, MSInspID, onSuccess_reopenInspection, onFail_reopenInspection, ctx);
                    $("#dvSectionViewInspectionTest").show();
                    if (msg) {
                        $("#msgResults").text(msg);
                    }
                }
                else {
                    if (!checkNullOrUndefined(msg)) {
                        alert(msg);
                    }
                }
            }
        }

        function onFail_canInspectionBeReopened(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_canInspectionBeReopened");
        }

        function onSuccess_canInspectionBeDeleted(value, ctx, methodName) {
            if (!checkNullOrUndefined(value)) {
                var canDelete = value[0];
                var msg = value[1];
                var MSInspID = ctx["MSInspID"];
                var MSID = ctx["MSID"];

                if (canDelete) {
                    var r = confirm("Continue deleting inspection? Deletion cannot be undone.");
                    if (true === r) {
                        PageMethods.deleteInspection(MSID, MSInspID, onSuccess_deleteInspection, onFail_deleteInspection, ctx);
                    }
                    PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                    $("#dvSectionViewInspectionTest").show();
                    if (msg) {
                        $("#msgResults").text(msg);
                    }
                }
                else {
                    if (!checkNullOrUndefined(msg)) {
                        alert(msg);
                    }
                }
            }
        }

        function onFail_canInspectionBeDeleted(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_canInspectionBeDeleted");
        }

        function onSuccess_canInspectionBeStarted(value, ctx, methodName) {
            if (!checkNullOrUndefined(value)) {
                var canStart = value[0];
                var msg = value[1];
                var MSInspID = ctx["MSInspID"];
                var MSID = ctx["MSID"];

                if (canStart) {
                    PageMethods.startInspection(MSID, MSInspID, onSuccess_startInspection, onFail_startInspection, ctx);
                    PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                    $("#dvSectionViewInspectionTest").show();
                }
                else {
                    if (!checkNullOrUndefined(msg)) {
                        alert(msg);
                    }
                }
            }
        }

        function onFail_canInspectionBeStarted(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_canInspectionBeStarted");
        }

        function onSuccess_updateInspectionComment(value, ctx, methodName) {
                <%-- add code as needed --%>
                $('#lblCommentUpdated').text("Comment Updated");
                $("#lblCommentUpdated").fadeIn(2000, function () { $('#lblCommentUpdated').fadeOut(3000); });

                var MSInspDetailID = $("#gridOfInspectionVersions").data("MSInspectionDetailID");
                PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
            }

            function onFail_updateInspectionComment(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_updateInspectionComment");
            }

            function onSuccess_updateLocation(value, newStatus, methodName) {
                <%--when moving locations, status is always set by default to waiting --%>
                var statusText = value[0];
                var statusID = value[1];
                $("#lblMsgcreateOrViewListAndInspections").text("");
                var newLocation = $("#cboxLocationStatus").igCombo("text");
                var dockSpot = $("#cboxDockSpots").igCombo("text");
                if (!checkNullOrUndefined(dockSpot)) {
                    newLocation = newLocation + " " + dockSpot;
                }
                $("#lblLoc").text($.trim(newLocation));
                $("#lblCurrentLocation").text($.trim(newLocation));
                $("#lblStat").text(statusText);
                $("#lblStatus").text(statusText);
                var msidItems = $("#cboxTruckList").igCombo("selectedItems")
                if (msidItems) {
                    for (i = 0; i < GLOBAL_TRUCK_DATA.length; i++) {
                        if (GLOBAL_TRUCK_DATA[i].MSID === msidItems[0].data.MSID) {
                            GLOBAL_TRUCK_DATA[i].LOCLONG = newStatus.LOCSTATTEXT;
                            GLOBAL_TRUCK_DATA[i].LOCSHORT = newStatus.LOCSTAT;
                            GLOBAL_TRUCK_DATA[i].STATUSID = statusID;
                            GLOBAL_TRUCK_DATA[i].STATUSTEXT = statusText;
                        }
                    }
                }

                <%--update to a valid status--%>
                $("#cboxTruckList").data("data-canCreateEditInspection", true);

                <%--re-pop truck log--%>
                var selectedTruck = $("#cboxTruckList").igCombo("selectedItems");
                if (selectedTruck) {
                    var MSID = selectedTruck[0].data.MSID
                    PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
                    PageMethods.getCurrentLocationAndStatus(MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus);
                }
                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
            }
            function onFail_updateLocation(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_updateLocation");
            }

            function onSuccess_createOrViewListAndInspections(value, ctx, methodName) {
                if (value && value.length > 0) {
                    var msg = value[0];
                    var MSInspectionListID = value[1];

                    $("#lblMsgcreateOrViewListAndInspections").text(msg);
                    if (MSInspectionListID > 0) {
                        PageMethods.getInspectionsUnderList(MSInspectionListID, onSuccess_getInspectionsUnderList, onFail_getInspectionsUnderList);
                    }
                }
            }

            function onFail_createOrViewListAndInspections(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_createOrViewListAndInspections");
            }
            function onSuccess_getInspectionsUnderList(value, ctx, methodName) {
                var gridData = [];
                gridData.length = 0;
                for (i = 0; i < value.length; i++) {
                    gridData[i] = {
                        "MSID": value[i][0], "MSINSPLISTDETAILID": value[i][1], "MSINSPECTLISTID": value[i][2], "HEADERNAME": value[i][3], "SORT": value[i][4]
                    };
                }
                $("#gridOfInspectionsUnderList").igGrid("option", "dataSource", gridData);
                $("#gridOfInspectionsUnderList").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
            }
            function onFail_getInspectionsUnderList(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getInspectionsUnderList");
            }

            function onSuccess_getInspectionAllVersionDetails(value, ctx, methodName) {
               <%--display grid --%>
                var gridData = [];
                gridData.length = 0;

                for (i = 0; i < value.length; i++) {
                    startTime = value[i][5];
                    var canView = false;
                    var canDelete = true; <%-- change as needed --%>
                    if (!checkNullOrUndefined(startTime)) {
                        canView = true;
                    }

                    var firstname = value[i][8];
                    var lastname = value[i][9];

                    if (checkNullOrUndefined(firstname)) {
                        firstname = "";
                    }
                    if (checkNullOrUndefined(lastname)) {
                        lastname = "";

                    }
                    var canCreateInspection = checkNullOrUndefined($("#cboxTruckList").data("data-canCreateEditInspection")) ? false : $("#cboxTruckList").data("data-canCreateEditInspection");
                    var isFailedValue = value[i][14];

                    gridData[i] = {
                        "MSINSPECTLISTID": value[i][0], "INSPECTLISTID": value[i][1], "HEADERID": value[i][2], "HEADERNAME": value[i][3], "VERSION": value[i][4], "STARTTIME": startTime, "ENDTIME": value[i][6],
                        "USERID": value[i][7], "NAME": firstname + " " + lastname, "INSPECTIONCOMMENTS": value[i][10], "MSINSPLISTDETAILID": value[i][11], "MSINSPID": value[i][12], "MSID": value[i][13],
                        "ISFAILEDVALUE": isFailedValue, "ISFAILEDVALUETEXT": isFailedValue, "AUTOCLOSED": value[i][15], "AUTOCLOSEDTEXT": value[i][15], "VIEW": canView, "DELETE": canDelete, "CANCREATE": canCreateInspection,
                    };
                }
                $("#gridOfInspectionVersions").igGrid("option", "dataSource", gridData);
                $("#gridOfInspectionVersions").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>

                if (!canCreateInspection) {
                    displayInspectionItems(inspectionActions.VIEW, true, true);
                }

            }
            function onFail_getInspectionAllVersionDetails(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getInspectionAllVersionDetails");
            }

            function onSuccess_deleteInspection(value, ctx, methodName) {
                $("#dvResults").hide();
                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                var MSInspDetailID = $("#gridOfInspectionVersions").data("MSInspectionDetailID");
                PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
            }

            function onFail_deleteInspection(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_deleteInspection");

            }

            function onSuccess_isInspectionClosed(value, ctx, methodName) {
                var MSInspID = ctx["MSInspID"];
                var MSID = ctx["MSID"];
                if (!checkNullOrUndefined(value)) {
                    ctx["isClosed"] = value;
                }
                $("#grid").data("IsInspectionClose", value);
                PageMethods.getInspectionGridData(MSInspID, onSuccess_getInspectionGridData, onFail_getInspectionGridData, ctx);
            }

            function onFail_isInspectionClosed(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_isInspectionClosed");
            }

            function onSuccess_startInspection(value, ctx, methodName) {
                var MSinspectionID = ctx["MSInspID"];
                var MSInspectionListID = ctx["MSInsListID"];
                var MSID = ctx["MSID"];

                PageMethods.getInspectionGridData(MSinspectionID, onSuccess_getInspectionGridData, onFail_getInspectionGridData, ctx);
                var MSInspDetailID = $("#gridOfInspectionVersions").data("MSInspectionDetailID");
                PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
                PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
            }
            function onFail_startInspection(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_startInspection");
            }
            function onSuccess_endInspectionWrapper(value, ctx, methodName) {
                var inspectionID = ctx["MSInspID"];
                var MSInspectionListID = ctx["MSInsListID"];
                var MSID = ctx["MSID"];

                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                PageMethods.getCurrentLocationAndStatus(MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus, ctx);
                var MSInspDetailID = $("#gridOfInspectionVersions").data("MSInspectionDetailID");
                PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
                PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
            }
            function onFail_endInspectionWrapper(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_endInspectionWrapper");
            }
            function onSuccess_reopenInspection(value, ctx, methodName) {
                var inspectionID = ctx["MSInspID"];
                var MSInspectionListID = ctx["MSInsListID"];
                var MSID = ctx["MSID"];

                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                PageMethods.getInspectionGridData(inspectionID, onSuccess_getInspectionGridData, onFail_getInspectionGridData, ctx);
                var MSInspDetailID = $("#gridOfInspectionVersions").data("MSInspectionDetailID");
                PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
                PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
            }
            function onFail_reopenInspection(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_reopenInspection");
            }

            function onSuccess_getInspectionResultTypes(value, ctx, methodName) {
                GLOBAL_INSPECTION_RESULTTYPES = [];
                GLOBAL_INSPECTION_RESULTTYPES.length = 0;
                for (i = 0; i < value.length; i++) {
                    <%--make sure the if statements match database entries in inspectionresulttype --%>
                    var rText = value[i][1].trim().toUpperCase();
                    if ("PASS" === rText) {
                        GLOBAL_INSPECTION_RESULTTYPES["PASS"] = { ResultValue: value[i][0], ResultText: value[i][1] };
                    }
                    else if ("FAIL" === rText) {
                        GLOBAL_INSPECTION_RESULTTYPES["FAIL"] = { ResultValue: value[i][0], ResultText: value[i][1] };
                    }
                    else if ("N/A" === rText) {
                        GLOBAL_INSPECTION_RESULTTYPES["NA"] = { ResultValue: value[i][0], ResultText: value[i][1] };
                    }
                }
            }
            function onFail_getInspectionResultTypes(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getInspectionResultTypes");
            }
            function getResultTypeDetailDataFromResult(result) {
                var outputObject = {
                    ResultValue: result,
                    ResultText: returnItemFromArray(GLOBAL_INSPECTION_RESULTTYPES, "RESULTTEXT", result, "RESULTVALUE"),
                    vPass: false,
                    vFail: false,
                    vNA: false,
                };


                <%--check onSuccess_getInspectionResultTypes() for GLOBAL_INSPECTION_RESULTTYPES attributes and match--%>
                if (GLOBAL_INSPECTION_RESULTTYPES.PASS.ResultValue === result) { //pass
                    outputObject.vPass = true;
                    outputObject.vFail = false;
                    outputObject.vNA = false;
                }
                else if (GLOBAL_INSPECTION_RESULTTYPES.FAIL.ResultValue === result) { //fail
                    outputObject.vFail = true;
                    outputObject.vPass = false;
                    outputObject.vNA = false;
                }
                else if (GLOBAL_INSPECTION_RESULTTYPES.NA.ResultValue === result) { //not applicable
                    outputObject.vPass = false;
                    outputObject.vFail = false;
                    outputObject.vNA = true;
                }
                return outputObject
            }
            function onSuccess_getInspectionGridData(value, ctx, methodName) {
                //GLOBAL_INSPECTION_DATA.length = 0 <%--make empty--%>
                gridValues = value[0];
                var gridData = [];
                gridData.length = 0;



                for (i = 0; i < gridValues.length; i++) {
                    var resultObject = getResultTypeDetailDataFromResult(gridValues[i][2]);
                    gridData[i] = {
                        "INSPID": gridValues[i][0], "TESTID": gridValues[i][1], "RESULT": gridValues[i][2], "RESULTTEXT": resultObject.ResultText, "TIMESTAMP": gridValues[i][3], "USERID": gridValues[i][4],
                        "COMMENT": gridValues[i][5], "TESTDESC": gridValues[i][6], "PASS": resultObject.vPass, "FAIL": resultObject.vFail, "NA": resultObject.vNA
                    }
                }
                $("#txtInspectionComment").val("")
                var inspectionComments = value[1];
                if (inspectionComments) {
                    $("#txtInspectionComment").val(inspectionComments)
                }
                $("#grid").igGrid("option", "dataSource", gridData);
                $("#grid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>

                if (ctx) {
                    var MSID = ctx["MSID"];
                    PageMethods.getCurrentLocationAndStatus(MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus, ctx);
                }
            }

            function onFail_getInspectionGridData(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getInspectionGridData");
            }

            function onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest(value, ctx, methodName) {
                var gridData = [];
                gridData.length = 0;
                for (i = 0; i < value.length; i++) {

                    var isInspectionComplete = false;
                    if (!checkNullOrUndefined(value[i][7])) {
                        isInspectionComplete = true;
                    }
                    var rejected = value[i][8];
                    var rejectedText = '';
                    if (rejected) {
                        rejectedText = 'Rejected';
                    }
                    var isFailed = value[i][11];
                    gridData[i] = {
                        "MSID": value[i][0], "ETA": value[i][1], "PONUM": value[i][2], "TRAILNUM": value[i][3], "INSP": value[i][4], "LOCSTAT": value[i][5],
                        "LOCLONG": value[i][6], "INSPCLOSED": isInspectionComplete, "REJECTED": rejected, "REJECTEDTEXT": rejectedText, "ISFAILEDVALUE": isFailed,
                        "PRODID": value[i][12], "PRODDETAIL": value[i][13]
                    };
                }
                $("#gridMissingResults").igGrid("option", "dataSource", gridData);
                $("#gridMissingResults").igGrid("dataBind");
                todayFilterForGridMissingResults();
            }
            function onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest");
            }

            function onSuccess_getAvailableLocations(value, ctx, methodName) {
                var cboxData = [];
                cboxData.length = 0;
                for (i = 0; i < value.length; i++) {
                    cboxData[i] = { "LOCSTAT": value[i][0], "LOCSTATTEXT": value[i][1] };
                }
                $("#cboxLocationStatus").igCombo("option", "dataSource", cboxData);
                $("#cboxLocationStatus").igCombo("dataBind");
            }
            function onFail_getAvailableLocations(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getAvailableLocations");
            }
            function disableInspectionButtons() {
                $(".disableableInspectionButtons").attr("disabled", "disabled");
            }
            function enableInspectionButtons() {
                $(".disableableInspectionButtons").removeAttr("disabled", "disabled");
            }

            function displayInspectionItems(iAction, isClosed, isFailed) {
                enableInspectionButtons();
                switch (iAction) {
                    case inspectionActions.START:
                        enableInspectionTests();
                        $("#dvResults").show();
                        break;
                    case inspectionActions.END:
                        disableInspectionTests();
                        $("#dvResults").show();
                        break;
                    case inspectionActions.REOPEN:
                        enableInspectionTests();
                        $("#dvResults").show();
                        break;
                    case inspectionActions.VIEW:
                        if (!checkNullOrUndefined(isClosed)) {
                            if (isClosed && isFailed) {
                                $("#dvResults").show();
                                disableInspectionTests();
                                var canEditCreateInspection = checkNullOrUndefined($("#cboxTruckList").data("data-canCreateEditInspection")) ? false : $("#cboxTruckList").data("data-canCreateEditInspection");
                                if (!canEditCreateInspection) {
                                    disableInspectionButtons();
                                }
                            }
                            else {
                                enableInspectionTests();
                                $("#dvResults").show();
                            }
                        }
                        break;
                    case inspectionActions.NONE:
                        <%-- //TODO: add as needed--%>
                        break;
                    default:
                        break;
                }
            }


            function setUIBasedOnUpdateStatusAbility(currentLocStatus, canUpdate) {
                var locShort = currentLocStatus[0];
                var statShort = currentLocStatus[1];
                var locLong = currentLocStatus[2];
                var statLong = currentLocStatus[3];
                var currentDockSpotLong = currentLocStatus[8];
                if (!checkNullOrUndefined(currentDockSpotLong)) {
                    locLong = locLong + " " + currentDockSpotLong;
                }
                if (canUpdate) {
                    $("#dvLocStat").show();
                    $("#btnUpdateLocation").prop('disabled', false);
                    $("#cboxLocationStatus").igCombo("value", locShort);
                    $("#lblLoc").text(locLong);
                    $("#lblCurrentLocation").text(locLong);
                    $("#lblStat").text(statLong);
                    $("#lblStatus").text(statLong);

                    if (locShort == "DOCKBULK" || locShort == "DOCKVAN") {
                        $("#dvLocDockSpot").show();
                    }
                    else {
                        $("#dvLocDockSpot").hide();
                    }
                }
                else {
                    $("#dvLocStat").hide();
                    $("#dvLocDockSpot").hide();
                    $("#btnUpdateLocation").prop('disabled', true);
                    $("#lblLoc").text(locLong);
                    $("#lblCurrentLocation").text(locLong);
                    $("#lblStat").text(statLong + "(Currently not eligible for location update)");
                    $("#lblStatus").text(statLong);
                }
            }
            function setTruckRejectedItems() {
                $("#lblisRejected").text("YES");
                $("#btnRejectTruck").hide();
                $("#grid").data("data-isRejected", true);
                viewOnlyMode(false);
            }
            function setTruckNotRejectedItems() {
                $("#lblisRejected").text("NO");
                $("#btnRejectTruck").show();
                $("#grid").data("data-isRejected", false);
                $("#btnUpdateInspectionComment").show();
                $("#txtInspectionComment").attr("disabled", false);
                $("#txtInspectionComment").attr("readonly", false);
            }
            function setUIBasedOnCanEditTestAbility(canEdit) {
                if (canEdit) {
                    $("#cboxTruckList").data("data-canCreateEditInspection", true);
                    $("#msgReadOnly").hide();
                }
                else {

                    viewOnlyMode(false);
                }
            }
            function onSuccess_getCurrentLocationAndStatus(currentLocStatus, ctx, methodName) {
                var canUpdateStatus = currentLocStatus[4];
                var canEditTest = currentLocStatus[5];
                var isRejected = currentLocStatus[6];
                <%-- set defaults --%>
                $("#cboxTruckList").data("data-canCreateEditInspection", false);
                // displayInspectionItems(inspectionActions.VIEW, true, true); <%--set display as viewable with no editing allowed --%>

                setUIBasedOnUpdateStatusAbility(currentLocStatus, canUpdateStatus);
                if (isRejected) {
                    setTruckRejectedItems();
                }
                else {
                    setTruckNotRejectedItems();
                    setUIBasedOnCanEditTestAbility(canEditTest);

                    if (ctx) {
                        var iAction = ctx["iAction"];
                        var isInspectionClosed = (checkNullOrUndefined(ctx["isClosed"]) ? false : ctx["isClosed"]);
                        var isInspectionFailed = (checkNullOrUndefined(ctx["isFailed"]) ? true : ctx["isFailed"]);
                        if (!checkNullOrUndefined(iAction) && !checkNullOrUndefined(isInspectionClosed) && !checkNullOrUndefined(isInspectionFailed)) {
                            displayInspectionItems(iAction, isInspectionClosed, isInspectionFailed);
                        }
                    }

                }
            }
            function onFail_getCurrentLocationAndStatus(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getCurrentLocationAndStatus");
            }
            
            function onSuccess_getTruckAndDataAvailableForInspections(value, ctx, methodName) {

                var cboxData = [];
                cboxData.length = 0;
                for (i = 0; i < value.length; i++) {
                    cboxData[i] = { "MSID": value[i][0], "PO": String(value[i][4]) + "-" + $.trim(value[i][6]) }; <%-- Use MSID for ID, and PONumber for Label --%>
                }
                $("#cboxTruckList").igCombo("option", "dataSource", cboxData);
                $("#cboxTruckList").igCombo("dataBind");

                <%--//Trucks Data--%>
            GLOBAL_TRUCK_DATA.length = 0;
            for (i = 0; i < value.length; i++) {
                var fullLocation = null;

                if (!checkNullOrUndefined(value[i][19])) {<%-- if in dock spot, pop location with dock spot--%>
                        fullLocation = value[i][15] + " " + value[i][19];
                    }
                    else {
                        fullLocation = value[i][15];
                    }

                    GLOBAL_TRUCK_DATA[i] = {
                        "MSID": value[i][0], "ETA": value[i][1], "CUSTID": value[i][2], "TRUCKTYPE": value[i][3], "PO": value[i][4], "LOADSHORT": value[i][5], "TRAILNUM": value[i][6],
                        "DROP": value[i][7], "CABIN": value[i][8], "CABOUT": value[i][9], "CARRIER": value[i][10], "SHIP": value[i][11], "LOAD": value[i][12],
                        "REJECT": value[i][13], "REJECTREASON": value[i][14], "LOCLONG": fullLocation, "LOCSHORT": value[i][16], "STATUSID": value[i][17], "STATUSTEXT": value[i][18], "TIMEREJECTED": value[i][20]
                    }; <%-- //Use MSID for ID, and PONumber for Label --%>
                }
            PageMethods.getAvailableLocations(onSuccess_getAvailableLocations, onFail_getAvailableLocations);
        }

        function onFail_getTruckAndDataAvailableForInspections(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_getTruckAndDataAvailableForInspections");
        }

            function onSuccess_getListofTrucksCurrentlyInZXP(value, ctx, methodName) {

                var cboxData = [];
                cboxData.length = 0;
                for (i = 0; i < value.length; i++) {
                    cboxData[i] = { "MSID": value[i][0], "PO": String(value[i][4]) + "-" + $.trim(value[i][6]) }; <%-- Use MSID for ID, and PONumber for Label --%>
                }
                $("#cboxTruckList").igCombo("option", "dataSource", cboxData);
                $("#cboxTruckList").igCombo("dataBind");

                <%--//Trucks Data--%>
                GLOBAL_TRUCK_DATA.length = 0;
                for (i = 0; i < value.length; i++) {
                    var fullLocation = null;

                    if (!checkNullOrUndefined(value[i][19])) {<%-- if in dock spot, pop location with dock spot--%>
                        fullLocation = value[i][15] + " " + value[i][19];
                    }
                    else {
                        fullLocation = value[i][15];
                    }

                    GLOBAL_TRUCK_DATA[i] = {
                        "MSID": value[i][0], "ETA": value[i][1], "CUSTID": value[i][2], "TRUCKTYPE": value[i][3], "PO": value[i][4], "LOADSHORT": value[i][5], "TRAILNUM": value[i][6],
                        "DROP": value[i][7], "CABIN": value[i][8], "CABOUT": value[i][9], "CARRIER": value[i][10], "SHIP": value[i][11], "LOAD": value[i][12],
                        "REJECT": value[i][13], "REJECTREASON": value[i][14], "LOCLONG": fullLocation, "LOCSHORT": value[i][16], "STATUSID": value[i][17], "STATUSTEXT": value[i][18], "TIMEREJECTED": value[i][20]
                    }; <%-- //Use MSID for ID, and PONumber for Label --%>
                }
                PageMethods.getAvailableLocations(onSuccess_getAvailableLocations, onFail_getAvailableLocations);
            }

            function onFail_getListofTrucksCurrentlyInZXP(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getListofTrucksCurrentlyInZXP");
            }


            function onSuccess_setInspectionResult(value, ctx, methodName) {
                var testID = ctx[0];
                if (value && ctx) {
                    var rDate = value[0];
                    var shouldDisableGrid = value[1];
                    var rMsg = value[2];

                    var ds = $("#grid").igGrid("option", "dataSource");
                    var newMonth = ("00" + (1 + rDate.getMonth())).slice(-2);
                    var newDay = ("00" + rDate.getDate()).slice(-2);
                    var newTimeStampString = (newMonth + '/' + newDay + '/' + rDate.getFullYear()) + " " + getNewTime(rDate);
                    var newTimeStamp = new Date(newTimeStampString);
                    $("#grid").data("igGrid").dataSource.setCellValue(testID, "TIMESTAMP", newTimeStamp, true);
                    $("#grid").igGrid("cellById", testID, "TIMESTAMP").text(newTimeStampString);
                    $("#grid").igGrid("commit");


                    if (shouldDisableGrid) {
                        if (!checkNullOrUndefined(rMsg)) {
                            alert(rMsg);
                        }
                        //TODO: call function that refreshes versions grid and disable results grid
                        disableInspectionTests();
                        $("#dvResults").show();
                        var MSInspDetailID = $("#gridOfInspectionVersions").data("MSInspectionDetailID");
                        PageMethods.getInspectionAllVersionDetails(MSInspDetailID, onSuccess_getInspectionAllVersionDetails, onFail_getInspectionAllVersionDetails);
                    }
                }
            }
            function onFail_setInspectionResult(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_setInspectionResult");
            }

            function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
                truckLog_OnSuccess_Render(returnValue, MSID);
            }

            function onFail_getLogDataByMSID(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx onFail_getLogDataByMSID");
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
                sendtoErrorPage("Error in inspectionNew.aspx onFail_getLogList");
            }

            function onSuccess_getProductsByMSID(products, ctx, methodName) {
                GLOBAL_PRODUCT_OPTIONS = [];
                for (i = 0; i < products.length; i++) {
                    GLOBAL_PRODUCT_OPTIONS.push({ "PRODID": products[i][0], "PRODNAME": products[i][1] });
                }
                $("#cboxProductInspectionFilter").igCombo("option", "dataSource", GLOBAL_PRODUCT_OPTIONS);
                $("#cboxProductInspectionFilter").igCombo("dataBind");
                $("#cboxProductInspectionFilter").igCombo("value", -1);
            }

            function onFail_getProductsByMSID(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getProductsByMSID");
            }

            function onSuccess_getProductsByMSIDwAll(products, ctx, methodName) {
                GLOBAL_PRODUCT_OPTIONS = [];
                for (i = 0; i < products.length; i++) {
                    GLOBAL_PRODUCT_OPTIONS.push({ "PRODID": products[i][0], "PRODNAME": "Part#: " + products[i][0] + ", Desc: " + products[i][1] });
                }
                $("#cboxProductInspectionFilter").igCombo("option", "dataSource", GLOBAL_PRODUCT_OPTIONS);
                $("#cboxProductInspectionFilter").igCombo("dataBind");
                $("#cboxProductInspectionFilter").igCombo("value", -1);
            }

            function onFail_getProductsByMSIDwAll(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getProductsByMSIDwAll");
            }

            function onSuccess_getInspectionListByProduct(products, ctx, methodName) {
                GLOBAL_INSPECTIONGROUP_OPTIONS = [];
                for (i = 0; i < products.length; i++) {
                    GLOBAL_INSPECTIONGROUP_OPTIONS.push({ "INSPECTGROUPID": products[i][0], "INSPECTGROUPNAME": products[i][1] });
                }
                $("#cboxInspectionGroupList").igCombo("option", "dataSource", GLOBAL_INSPECTIONGROUP_OPTIONS);
                $("#cboxInspectionGroupList").igCombo("dataBind");
                $("#cboxInspectionGroupList").igCombo("value", -1);
            }

            function onFail_getInspectionListByProduct(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getProductsByMSIDwAll");
            }
            function onSuccess_getLocationOptions(returnValue, MSID, methodName) {
                var locationData = [];
                for (i = 1; i < returnValue.length; i++) { //start at one to not add current location
                    locationData.push({ "LOCSTAT": returnValue[i][0], "LOCSTATTEXT": returnValue[i][1] });
                }
                $("#cboxLocationStatus").igCombo("option", "dataSource", locationData);
                $("#cboxLocationStatus").igCombo("dataBind");
                PageMethods.getAvailableDockSpots(MSID, onSuccess_getAvailableDockSpots, onFail_getAvailableDockSpots, MSID);
            }

            function onFail_getLocationOptions(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getLocationOptions");
            }
            function onSuccess_getAvailableDockSpots(value, MSID, methodName) {
                var dockSpot = [];
                for (i = 0; i < value.length; i++) {
                    dockSpot[i] = { "SPOTID": value[i][0], "DOCKSPOT": value[i][1] };
                }
                $("#cboxDockSpots").igCombo("option", "dataSource", dockSpot);
                $("#cboxDockSpots").igCombo("dataBind");
                PageMethods.getCurrentDockSpot(MSID, onSuccess_getCurrentDockSpot, onFail_getCurrentDockSpot, MSID);
            }

            function onFail_getAvailableDockSpots(value, ctx, methodName) {
                sendtoErrorPage("Error in Samples.aspx onFail_getAvailableDockSpots");
            }

            function onSuccess_getCurrentDockSpot(currentOrAssignedSpot, MSID, methodName) {
                //clear selection
                $("#cboxDockSpots").igCombo("value", null);
                // 0 = no spot, 3015 = Yard, & 3017 = Wait Area
                if (currentOrAssignedSpot != 0 && currentOrAssignedSpot != 3015 && currentOrAssignedSpot != 3017) {
                    $("#cboxDockSpots").igCombo("value", currentOrAssignedSpot);
                }
                PageMethods.getCurrentLocationAndStatus(MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus);
            }

            function onFail_getCurrentDockSpot(value, ctx, methodName) {
                sendtoErrorPage("Error in Samples.aspx onFail_getCurrentDockSpot");
            }

            function onSuccess_getFileUploadsFromMSID(value, MSID, methodName) {
            <%--clear data from controls --%>
                $('#alinkBOL').text("");
                $('#alinkCOFA').text("");
                $('#dUpBOL').show();
                $('#dDelBOL').hide();
                $('#dUpCOFA').show();
                $('#dDelCOFA').hide();

                var rowID = $('#dwFileUpload').data("data-rowID");
                if (value.length > 0) {
                    var gridData = [];

                    var rowCount = 0;
                    for (var i = 0; i < value.length; i++) {
                        gridData[i] = { "FID": value[i][0], "MSID": value[i][1], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5], "FNAMEOLD": value[i][6], "FUPDEL": "" };
                    }

                    $("#gridFiles").igGrid("option", "dataSource", gridData);
                    $("#gridFiles").igGrid("dataBind");
                }
                $("#dwFileUpload").igDialog("open");
            }

            function onFail_getFileUploadsFromMSID(value, ctx, methodName) {
                sendtoErrorPage("Error in inspectionNew.aspx, onFail_getFileUploadsFromMSID");
            }

            function openUploadDialog(MSID) {
                $('#dwFileUpload').data("data-MSID", MSID);
                PageMethods.getFileUploadsFromMSID(MSID, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, MSID);
            }

            function onSuccess_processFileAndData(value, FileInfo, methodName) {
                if (FileInfo) {
                    var fileuploadType = FileInfo[1];
                    if ("IMAGE" === fileuploadType) {
                        //Add entry into DB 
                        var timestamp = new Date().toLocaleDateString();
                        var imageDescription = "Inspections Uploaded Image " + timestamp;
                        PageMethods.addFileDBEntry(FileInfo[2], "IMAGE", FileInfo[0], value[1], value[0], imageDescription, onSuccess_addFileDBEntry, onFail_addFileDBEntry, FileInfo)
                    }
                    else if ("OTHER" === fileuploadType) {
                    <%--Add OTHER filetype entry into db only happens on add row finished because need to get Detail column--%>
                    <%--add attributes related to grid for use when adding new row --%>
                    $("#gridFiles").data("data-FPath", value[0]);
                    $("#gridFiles").data("data-FNameNew", value[1]);
                    $("#gridFiles").data("data-FNameOld", FileInfo[0]);

                    <%--change text of add new row's filename column to uploaded file's original name --%>
                    $("#dwFileUpload tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(FileInfo[0]);
                }
        }
    }

    function onFail_processFileAndData(value, ctx, methodName) {
        sendtoErrorPage("Error in inspectionNew.aspx, onFail_processFileAndData");
    }
    function onSuccess_addFileDBEntry(value, ctx, methodName) {
        var msid = $('#dwFileUpload').data("data-MSID");
        if (!checkNullOrUndefined(msid)) {
            PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
        }
    }

    function onFail_addFileDBEntry(value, ctx, methodName) {
        sendtoErrorPage("Error in inspectionNew.aspx, onFail_addFileDBEntry");
    }

    function onSuccess_updateFileUploadData(value, ctx, methodName) {
            <%--Success do nothing --%>
            $("#gridFiles").igGrid("commit");
        }
        function onFail_updateFileUploadData(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_updateFileUploadData");
        }

        function onSuccess_deleteFileDBEntry(value, rowID, methodName) {
            $("#gridFiles").igGridUpdating("deleteRow", rowID);
            $("#gridFiles").igGrid("commit");
            var msid = $('#dwFileUpload').data("data-MSID");
            PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
        }

        function onFail_deleteFileDBEntry(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionNew.aspx, onFail_deleteFileDBEntry");
        }

            <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
        $(function () {
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

            $("#cboxDockSpots").igCombo({
                dataSource: null,
                textKey: "DOCKSPOT",
                valueKey: "SPOTID",
                width: "200px",
                autoComplete: true,
                enableClearButton: false
            });

            $.ig.EditorProviderRadio = $.ig.EditorProviderRadio || $.ig.EditorProvider.extend({
                createEditor: function (updating, key, columnSetting, tabIndex) {
                    if (updating.options.editMode !== "row")
                        throw new Error("Only editMode: 'row' is supported by EditorProviderRadio class");
                    var label, input, settings = {}, radioGroup;
                    if (columnSetting) {
                        settings = columnSetting.editorOptions || settings;
                    }
                    radioGroup = settings.radioGroup || "ig_radioGroup1";
                    input = $("<input class = 'radButtonLarger' type='radio' name='" + radioGroup + "'/>");
                    label = $("<label  tabindex='" + tabIndex + "'></label>");
                    // this will enable the "Done" button
                    input.change(function (evt) {
                        updating._notifyChanged();

                    });
                    if (settings.id) {
                        input.attr('id', settings.id);
                    }
                    this.input = input;
                    this.label = label;
                    return this.label.append(this.input);
                },
                getValue: function () {
                    return this.input.is(":checked");
                },
                setValue: function (val) {

                    return this.input.attr("checked", val);
                    alert("Setting value");
                },
                setSize: function (width, height) {
                    //var back = this.label.parent().css('backgroundColor');
                    this.label.css({
                        width: width - 2,//adjust for border
                        height: height - 2,//adjust for border
                        //backgroundColor: back,//no transparency
                        borderStyle: "solid",//enable border (as for all editors)
                        borderWidth: "1px",//enable border (as for all editors)
                        backgroundPositionY: "9px"//shift background image which represents line of slider ~ to center
                    }).addClass('ui-corner-all');
                    this.input.css({
                        width: "100%",
                        margin: "0px"
                    });
                },
                setFocus: function () {
                    this.input.focus();
                },
                validator: function () {
                    // radio has no validator
                    return null;
                }
            });


            function radioFormatter(val) {
                return "<input class= 'radButtonLarger' style='width:100%; margin: 0px;'  type='radio' " + (val === true ? "checked='checked'" : '') + " />";
            }

            $("#grid").igGrid({
                dataSource: [],
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                autoCommit: true,
                primaryKey: "TESTID",
                columns:
                    [
                        { headerText: "", key: "INSPID", dataType: "number", width: "0px", },
                        { headerText: "", key: "TESTID", dataType: "number", width: "0px", },
                        { headerText: "", key: "RESULT", dataType: "number", width: "0px", },
                        { headerText: "", key: "USERID", dataType: "number", width: "0px", hidden: true },
                        {
                            headerText: "Needs Result", key: "NEEDINPUT", dataType: "integer", width: "60px", template: "{{if(${RESULT} === -999)}}" +
                                              "<div class ='needsTestInput'>NEEDS INPUT</div>{{else}}<div>DONE</div>{{/if}}"
                        },
                        {
                            headerText: "Not Applicable", key: "NA", dataType: "boolean", width: "100px", template: "<input id='radNA_${TESTID}' class= 'radButtonLarger' style='width:100%; margin: 0px;'   onclick = 'OnRadioButtonClick(${TESTID}, ${INSPID}, -1, ${NA}); return false;' type='radio' {{if(${NA} === true)}} checked='checked' {{/if}} />"
                        },
                        {
                            headerText: "Pass", key: "PASS", dataType: "boolean", width: "60px", template: "<input id='radPass_${TESTID}'  class= 'radButtonLarger' style='width:100%; margin: 0px;'  onclick = 'OnRadioButtonClick(${TESTID}, ${INSPID}, 1, ${PASS}); return false;' type='radio' {{if(${PASS}=== true)}} checked='checked' {{/if}} />"
                        },
                        {
                            headerText: "Fail", key: "FAIL", dataType: "boolean", width: "60px", template: "<input id='radFail_${TESTID}'  class= 'radButtonLarger' style='width:100%; margin: 0px;'  onclick = 'OnRadioButtonClick(${TESTID}, ${INSPID}, 0, ${FAIL}); return false;' type='radio' {{if(${FAIL}=== true)}} checked='checked' {{/if}} />"
                        },

                        //WORKING 
                        //{
                        //    headerText: "Not Applicable", key: "NA", dataType: "boolean", width: "100px", formatter: radioFormatter //template: "<input class= 'radButtonLarger' style='width:100%; margin: 0px;'  onclick ='OnRadioButtonClick(${TESTID}, ${INSPID}, -1); return false;' type='radio'{{if(${NA})}} checked='checked' {{/if}}/> "
                        //    //"{{else}} <input class= 'radButtonLarger' style='width:100%; margin: 0px;'  onclick ='OnRadioButtonClick(${TESTID}, ${INSPID}, -1); return false;' type='radio'/> {{/if}}"
                        //},
                        //{
                        //    headerText: "Pass", key: "PASS", dataType: "boolean", width: "60px", formatter: radioFormatter //template: "<input class= 'radButtonLarger' style='width:100%; margin: 0px;'  onclick = 'OnRadioButtonClick(${TESTID}, ${INSPID}, 0, ${PASS}); return false;' type='radio' {{if(${PASS})}} checked='checked' {{/if}} />"
                        //},
                        //{
                        //    headerText: "Fail", key: "FAIL", dataType: "boolean", width: "60px", formatter: radioFormatter //template: "<input class= 'radButtonLarger' style='width:100%; margin: 0px;'  onclick = 'OnRadioButtonClick(${TESTID}, ${INSPID}, 1, ${FAIL}); return false;' type='radio' {{if(${FAIL})}} checked='checked' {{/if}} />" 
                        //},
                        //END WORKING 

                        { headerText: "Test", key: "TESTDESC", dataType: "string", width: "500px", },
                        { headerText: "Comment", key: "COMMENT", dataType: "string", width: "400px", },
                        { headerText: "Time Edited", key: "TIMESTAMP", dataType: "date", width: "125px", format: "MM/dd/yyyy HH:mm:ss", }
                    ],
                features: [

                      {
                          name: 'Updating',
                          columnSettings:
                              [

                              { columnKey: "INSPID", readOnly: true },
                              { columnKey: "TESTID", readOnly: true },
                                    { columnKey: "NEEDINPUT", readOnly: true },
                                    { columnKey: "TESTDESC", readOnly: true },
                                    {
                                        columnKey: "TIMESTAMP",
                                    },
                                    {
                                        columnKey: "NA",
                                        editorProvider: new $.ig.EditorProviderRadio(),
                                        editorOptions: { radioGroup: "group1" },
                                        readOnly: true
                                    },
                                    {
                                        columnKey: "PASS",
                                        editorProvider: new $.ig.EditorProviderRadio(),
                                        editorOptions: { radioGroup: "group1" },
                                        readOnly: true
                                    },
                                    {
                                        columnKey: "FAIL",
                                        editorProvider: new $.ig.EditorProviderRadio(),
                                        editorOptions: { radioGroup: "group1" },
                                        readOnly: true
                                    },
                                    {
                                        columnKey: "COMMENT",
                                        editorType: "text",
                                        editorOptions: {
                                            maxLength: 250
                                        }
                                    },
                              ],
                          enableAddRow: false,
                          editMode: "row",
                          enableDeleteRow: false,
                          showReadonlyEditors: false,
                          enableDataDirtyException: false,
                          autoCommit: false,
                          editRowEnded: function (evt, ui) {
                              if (ui.update) {
                                  var rowNew = ui.values;
                                  var row = ui.owner.grid.findRecordByKey(ui.rowID);

                                  var MSID = $("#cboxTruckList").igCombo("value");
                                  if (ui.oldValues.COMMENT != rowNew.COMMENT) {
                                      var resultData = [];
                                      resultData[0] = ui.rowID;
                                      resultData[1] = null;
                                      PageMethods.setInspectionResult(MSID, row.INSPID, row.TESTID, null, rowNew.COMMENT, onSuccess_setInspectionResult, onFail_setInspectionResult, resultData);
                                  }
                              }
                          },
                      }
                ]
            }); <%--end of $("#grid").igGrid({--%>

            $("#gridOfInspectionsUnderList").igGrid({
                dataSource: [],
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "MSINSPDETAILID",
                columns:
                    [

                        { headerText: "", key: "MSID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "MSINSPLISTDETAILID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "MSINSPECTLISTID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "List Order", key: "SORT", dataType: "number", width: "55px", },
                        { headerText: "Inspection Name", key: "HEADERNAME", dataType: "text", width: "400px", },
                        {
                            headerText: "View Versions Under Inspection", key: "ViewAllVersions", dataType: "text", width: "200px",
                            template: "<div class ='ColumnContentExtend'>" +
                                            "<input id='btnViewAllVersions'+ type='button' value='View Versions' onclick='onclick_ViewAllVersionsOfInspection(${MSINSPLISTDETAILID}, \"${HEADERNAME}\", ${SORT})' class='ColumnContentExtend'/>" +
                                        "</div>"
                        },

                    ],

            });


            $("#gridOfInspectionVersions").igGrid({
                dataSource: [],
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "MSINSPDETAILID",
                columns:
                  [

                        { headerText: "", key: "MSID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "MSINSPLISTDETAILID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "MSINSPID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "MSINSPECTLISTID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "INSPECTLISTID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "HEADERID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "USERID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "ISFAILEDVALUE", dataType: "bool", width: "0px", hidden: true },
                        { headerText: "", key: "AUTOCLOSED", dataType: "bool", width: "0px", hidden: true },
                        {
                            headerText: "Image Upload", key: "CAMERA", dataType: "text", width: "60px", template:
                            "<img id = 'CameraImg' src ='Images/camera48x48.png' onclick='OnClick_AddImage(event,${MSID}, ${MSINSPLISTDETAILID}); return false;'/>"
                        },
                         {
                             headerText: "File Upload", key: "FUPLOAD", dataType: "string", width: "100px", template: "{{if(${MSID} !== -1)}} " +
                                 "<div><input type='button' value='View/Upload' onclick='openUploadDialog(${MSID}); return false;'></div>" +
                                 "{{else}} <div>(N/A)</div>{{/if}}"
                         },
                        { headerText: "Inspection Failed", key: "ISFAILEDVALUETEXT", dataType: "bool", width: "80px", formatter: boolYesNoFormatter },
                        { headerText: "Auto Closed", key: "AUTOCLOSEDTEXT", dataType: "bool", width: "80px", formatter: boolYesNoFormatter },
                        { headerText: "Version #", key: "VERSION", dataType: "number", width: "55px", },
                        { headerText: "Inspection Name", key: "HEADERNAME", dataType: "text", width: "125px", },
                        { headerText: "Inspection Started", key: "STARTTIME", dataType: "date", width: "100px", format: "MM/dd/yyyy HH:mm", },
                        { headerText: "Inspection Ended", key: "ENDTIME", dataType: "date", width: "100px", format: "MM/dd/yyyy HH:mm", },
                        { headerText: "Done By:", key: "NAME", dataType: "text", width: "80px", },
                        {
                            headerText: "Start/ End/ Reopen", key: "INSPECTTASK", dataType: "text", width: "150px",
                            template: "{{if(checkNullOrUndefined(${STARTTIME}) ) === true}}<div class ='ColumnContentExtend disableableInspectionButtons'><button id='btnInspectionStart' onclick='onclick_StartInspection(${MSINSPID}, ${MSID}, ${MSINSPECTLISTID}, \"${HEADERNAME}\", ${ISFAILEDVALUE});' class='ColumnContentExtend'>Start</button></div>" +
                                "{{elseif (checkNullOrUndefined(${ENDTIME}) && !checkNullOrUndefined(${STARTTIME})) === true}}<div class ='ColumnContentExtend disableableInspectionButtons'><button id='btnInspectionEnd'" +
                                                                    "onclick='onclick_EndInspection( ${MSINSPID}, ${MSID}, ${MSINSPECTLISTID}, \"${HEADERNAME}\", ${ISFAILEDVALUE});' class='ColumnContentExtend'>End</button></div>" +
                                "{{elseif (!checkNullOrUndefined(${ENDTIME}) && !checkNullOrUndefined(${STARTTIME}) ) === true}}<div class ='ColumnContentExtend disableableInspectionButtons'><button id='btnInspectionReopen'" +
                                                                    "onclick='onclick_ReopenAndUpdateInspection(${MSINSPID}, ${MSID}, ${MSINSPECTLISTID},\"${HEADERNAME}\", ${ISFAILEDVALUE});' class='ColumnContentExtend'>Reopen</button></div>" +
                                "{{else}}Data Error: Please Notify Your IT or App Administrator {{/if}}"
                        },
                        {
                            headerText: "View", key: "VIEW", dataType: "text", width: "175px",
                            template: "{{if(${VIEW})}}<div class ='ColumnContentExtend'><input id='btnViewInspection_${MSINSPID}' type='button' value='View Inspection' " +
                                                                    "onclick='onclick_ViewInspection(${MSINSPID}, ${MSID}, ${MSINSPECTLISTID}, \"${HEADERNAME}\", ${ISFAILEDVALUE});' class='ColumnContentExtend'/></div>" +
                                "{{else}}<div></div> {{/if}}"
                        },
                        {
                            headerText: "Delete", key: "DELETE", dataType: "text", width: "175px",
                            template: "{{if(${DELETE})}}<div class ='ColumnContentExtend disableableInspectionButtons'><button id='btnDeleteInspection' onclick='onclick_DeleteInspection(${MSINSPID}, ${MSID}, ${MSINSPECTLISTID});' class='ColumnContentExtend'>Delete Inspection</button></div>" +
                                "{{else}}<div></div> {{/if}}"
                        },
                        { headerText: "Inspection Comments", key: "INSPECTIONCOMMENTS", dataType: "text", width: "200px" },
                  ],
            });


            $("#gridMissingResults").igGrid({
                dataSource: [],
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [

                        { headerText: "", key: "MSID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "LOCSTAT", dataType: "text", width: "0px", hidden: true },
                        { headerText: "", key: "REJECTED", dataType: "text", width: "0px", hidden: true },
                        {
                            headerText: "Rejected", key: "REJECTEDTEXT", dataType: "text", width: "65px", template: "{{if(${REJECTED})}}" +
                                        "<div class ='needsTruckMove'>${REJECTEDTEXT}</div>{{else}}<div>${REJECTEDTEXT}</div>{{/if}}"
                        },
                        { headerText: "PO", key: "PONUM", dataType: "number", width: "90px", },
                        { headerText: "Trailer#", key: "TRAILNUM", dataType: "text", width: "150px", },
                         {
                             headerText: "Product", key: "PRODID", dataType: "string", width: "150px"
                         },
                         {
                             headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px"
                         },
                        { headerText: "ETA", key: "ETA", dataType: "date", width: "125px", format: "MM/dd/yyyy HH:mm", },
                        { headerText: "Location", key: "LOCLONG", dataType: "text", width: "125px" },
                        {
                            headerText: "Inspection Finished", key: "INSPCLOSED", dataType: "text", width: "125px", formatter: boolYesNoFormatter,
                        },
                        { headerText: "Inspection Failed", key: "ISFAILEDVALUE", dataType: "bool", width: "175px", formatter: boolYesNoFormatter },

                        { headerText: "Inspection Name", key: "INSP", dataType: "text", width: "175px", },
                    ],
                features: [
                           {
                               name: "Filtering",
                               dataFiltering: function (evt, ui) {

                                   var nExpressions = [];
                                   for (i = 0; i < ui.newExpressions.length; i++) {
                                       var newcond = ui.newExpressions[i].cond;
                                       var newExpr = ui.newExpressions[i].expr;
                                       var newFieldName = ui.newExpressions[i].fieldName;
                                       if (!checkNullOrUndefined(newExpr)) {
                                           if (newFieldName.contains("ETA")) {
                                               ui.newExpressions[i].preciseDateFormat = null;
                                           }

                                           nExpressions.push(ui.newExpressions[i]);
                                       }

                                   }
                                   $("#gridMissingResults").igGridFiltering("filter", nExpressions);
                                   return false;
                               },
                           }
                ]

            }); <%--end of $("#gridMissing")--%>


            $("#cboxProductInspectionFilter").igCombo({
                dataSource: null,
                textKey: "PRODNAME",
                valueKey: "PRODID",
                width: "200px",
                dropDownWidth: "600px",
                enableClearButton: false,
                mode: "editable",
                highlightMatchesMode: "contains",
                filteringCondition: "contains",
                autoSelectFirstMatch: false,
                selectionChanging: function (evt, ui) {
                    $("#dvInspectionListFilter").hide();
                    $("#dvInspectionListData_Details").hide();
                    $("#dvInspectionList_InspectionNames").hide();
                    $("#dvInspectionListVersionFilter").hide();

                    $("#dvSectionViewInspectionTest").hide();
                    $("#lblMsgcreateOrViewListAndInspections").text("");

                },
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        $("#dvInspectionListFilter").show();
                        var prodName = ui.items[0].data.PRODID;
                        var MSID = $("#cboxTruckList").igCombo("selectedItems")[0].data.MSID;
                        PageMethods.getInspectionListByProduct(prodName, MSID, onSuccess_getInspectionListByProduct, onFail_getInspectionListByProduct);
                    }
                }
            });


            $("#cboxInspectionGroupVersionList").igCombo({
                dataSource: GLOBAL_INSPECTIONGROUP_OPTIONS,
                textKey: "INSPECTVERSION", //should be inspectionlistname + run number
                valueKey: "INSPECTIONLISTID", //msinspectionlistid
                width: "200px",
                autoComplete: true,
                enableClearButton: false,
                selectionChanging: function (evt, ui) {
                    $("#dvSectionViewInspectionTest").hide();
                    $("#dvInspectionListData_Details").hide();
                    $("#dvInspectionList_InspectionNames").hide();
                    $("#lblMsgcreateOrViewListAndInspections").text("");
                    $("#btnCreateInspectionList").hide();
                    $("#btnViewInspectionList").hide();
                    $("#dvSectionViewInspectionTest").hide();
                },
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        if (ui.items[0].data.INSPECTIONLISTID > 0) {
                            $("#btnCreateInspectionList").hide();
                            $("#btnViewInspectionList").show();
                        }
                        else {
                            $("#btnCreateInspectionList").show();
                            $("#btnViewInspectionList").hide();
                        }
                    }
                        <%-- Currently handled in button click event onclick_createOrViewListAndInspections--%>
                    }
                });


            $("#cboxInspectionGroupList").igCombo({
                dataSource: GLOBAL_INSPECTIONGROUP_OPTIONS,
                textKey: "INSPECTGROUPNAME",
                valueKey: "INSPECTGROUPID",
                width: "200px",
                autoComplete: true,
                enableClearButton: false,
                selectionChanging: function (evt, ui) {
                    $("#dvSectionViewInspectionTest").hide();
                    $("#dvInspectionListData_Details").hide();
                    $("#dvInspectionList_InspectionNames").hide();
                    $("#dvInspectionListVersionFilter").show();
                    $("#btnCreateInspectionList").hide();
                    $("#btnViewInspectionList").hide();
                    $("#lblMsgcreateOrViewListAndInspections").text("");
                    $("#dvSectionViewInspectionTest").hide();
                },
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        var productItems = $("#cboxProductInspectionFilter").igCombo("selectedItems");
                        var msidItems = $("#cboxTruckList").igCombo("selectedItems");
                        if (msidItems && productItems) {
                            var MSID = msidItems[0].data.MSID;
                            var inspectionListID = ui.items[0].data.INSPECTGROUPID;
                            var productCMS = productItems[0].data.PRODID
                            PageMethods.getInspectionListVersionsByListID(MSID, inspectionListID, productCMS, onSuccess_getInspectionListVersionsByListID, onFail_getInspectionListVersionsByListID);
                        }
                    }

                        <%-- Currently handled in button click event onclick_createOrViewListAndInspections--%>
                    }
                });


            $("#cboxLocationStatus").igCombo({
                dataSource: [{ "LOCSTATTEXT": null, "LOCSTAT": null }],
                textKey: "LOCSTATTEXT",
                valueKey: "LOCSTAT",
                width: "200px",
                autoComplete: true,
                mode: "dropdown",
                selectionChanged: function (evt, ui) {
                    if (ui.items[0].data.LOCSTAT == "DOCKBULK" || ui.items[0].data.LOCSTAT == "DOCKVAN") {
                        $("#dvLocDockSpot").show();
                    }
                    else {
                        $("#dvLocDockSpot").hide();
                    }
                }

            });


            $("#cboxTruckList").igCombo({
                dataSource: null,
                textKey: "PO",
                valueKey: "MSID",
                width: "200px",
                enableClearButton: false,
                mode: "editable",
                highlightMatchesMode: "contains",
                filteringCondition: "contains",
                autoSelectFirstMatch: false,
                selectionChanging: function (evt, ui) {
                    $("#msgReadOnly").hide();
                    $("#dvResults").hide();
                    $("#spPOTrailer1").text("");
                    $("#spPOTrailer2").text("");
                    $("#spPOTrailer3").text("");
                    $("#spPOTrailer4").text("");
                    $("#spPOTrailer5").text("");


                    $("#dvInspectionListVersionFilter").hide();
                    $("#dvSectionViewInspectionTest").hide();
                    $("#dvInspectionListFilter").hide();
                    $("#dvInspectionListData_Details").hide();
                    $("#dvInspectionList_InspectionNames").hide();
                    $("#lblMsgcreateOrViewListAndInspections").text("");
                    $("#dvSectionViewInspectionTest").hide();

                    hideAllSections();


                },
                selectionChanged: function (evt, ui) {
                    if (ui.items.length == 1) {

                        //get data for grid summary for po selected
                        if (ui.items.length > 0) {
                            var pad = "00";
                            for (i = 0; i < GLOBAL_TRUCK_DATA.length; i++) {
                                if (GLOBAL_TRUCK_DATA[i].MSID === ui.items[0].data.MSID) {

                                    //set header titles
                                    $("#spPOTrailer1").text("for PO: " + $.trim(String(GLOBAL_TRUCK_DATA[i].PO)) + ", Trailer#: " + $.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));
                                    $("#spPOTrailer2").text("for PO: " + $.trim(String(GLOBAL_TRUCK_DATA[i].PO)) + ", Trailer#: " + $.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));
                                    $("#spPOTrailer3").text("for PO: " + $.trim(String(GLOBAL_TRUCK_DATA[i].PO)) + ", Trailer#: " + $.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));
                                    $("#spPOTrailer4").text("for PO: " + $.trim(String(GLOBAL_TRUCK_DATA[i].PO)) + ", Trailer#: " + $.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));
                                    $("#spPOTrailer5").text("for PO: " + $.trim(String(GLOBAL_TRUCK_DATA[i].PO)) + ", Trailer#: " + $.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));

                                    //set drop trailer label
                                    var rDrop;
                                    if (GLOBAL_TRUCK_DATA[i].DROP) { rDrop = "YES"; } else { rDrop = "NO"; }
                                    $("#lblDrop").text($.trim(rDrop));

                                    //format ETA
                                    var d = new Date(GLOBAL_TRUCK_DATA[i].ETA),
                                    dHr = d.getHours(),
                                    dMin = d.getMinutes(),
                                    dSec = d.getSeconds(),
                                    dformat = [(d.getMonth() + 1),
                                    d.getDate(),
                                    d.getFullYear()].join('/') + ' ' +
                                    [d.getHours().padLeft(),
                                    d.getMinutes().padLeft(),
                                    d.getSeconds().padLeft()].join(':');
                                    $("#lblETA").text($.trim(dformat));

                                    //set labels
                                    $("#lblPO").text($.trim(String(GLOBAL_TRUCK_DATA[i].PO)));
                                    $("#lblCurrentLocation").text(GLOBAL_TRUCK_DATA[i].LOCLONG);//asd
                                    $("#lblLoc").text(GLOBAL_TRUCK_DATA[i].LOCLONG);
                                    $("#lblStat").text($.trim(GLOBAL_TRUCK_DATA[i].STATUSTEXT));
                                    $("#lblStatus").text($.trim(GLOBAL_TRUCK_DATA[i].STATUSTEXT));
                                    $("#lblTruckType").text($.trim(GLOBAL_TRUCK_DATA[i].TRUCKTYPE));
                                    $("#lblLoad").text($.trim(GLOBAL_TRUCK_DATA[i].LOAD));
                                    $("#lblTrailNum").text($.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));


                                        <%--showing reject comment; if truck was previously rejected and then passed but comment was not cleared display to user anyways in case of important detail--%>
                                        $("#lblRejectTruck").text($.trim(GLOBAL_TRUCK_DATA[i].REJECTREASON));


                                        //set time rejected
                                        $("#lblTimeRejected").text(""); //reset
                                        if (!checkNullOrUndefined(GLOBAL_TRUCK_DATA[i].TIMEREJECTED)) {
                                            var rDate = new Date(GLOBAL_TRUCK_DATA[i].TIMEREJECTED);
                                            $("#lblTimeRejected").text((1 + rDate.getMonth()).toString() + "/" + rDate.getDate().toString() + "/" + rDate.getFullYear().toString() + " " + ("00" + rDate.getHours()).slice(-2) + ":" + ("00" + rDate.getMinutes()).slice(-2));
                                        }

                                    }
                                }
                            }

                            PageMethods.getLogDataByMSID(ui.items[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, ui.items[0].data.MSID);
                            //repopulate incomplete grid list
                            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                            //PageMethods.getCurrentLocationAndStatus(ui.items[0].data.MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus); zxc
                            PageMethods.getLocationOptions(ui.items[0].data.MSID, onSuccess_getLocationOptions, onFail_getLocationOptions, ui.items[0].data.MSID);
                            PageMethods.getProductsByMSIDwAll(ui.items[0].data.MSID, onSuccess_getProductsByMSIDwAll, onFail_getProductsByMSIDwAll);
                            showAllSections();

                        }

                    }
                });


            $("#dwFileUpload").igDialog({
                width: "600px",
                height: "550px",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {
                        <%-- Delete attributes on controls --%>

                        //TODO: change to removeData and attr to data and test
                        $("#gridFiles").removeData("data-FPath");
                        $("#gridFiles").removeData("data-FNameNew");
                        $("#gridFiles").removeData("data-FNameOld");
                        $("#dwFileUpload").removeData("data-MSID");
                        $('#dBOLcontainer').removeData("data-fileID");
                        $('#dCOFAcontainer').removeData("data-fileID");

                        $("#dwFileUpload span.anr_t:contains('Add new file')").text("Add new row"); <%-- change back label on grid --%>
                         $('#dwFileUpload td[title="Click to start adding new file"]').attr('title', "Click to start adding new row");
                     }
                     else if (ui.action === "open") {
                     }
                }
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
                                var msid = $("#dwFileUpload").data("data-MSID");
                                var desc = ui.values.DESC;

                                PageMethods.addFileDBEntry(msid, "OTHER", fnameOld, fnameNew, fpath, desc, onSuccess_addFileDBEntry, onFail_addFileDBEntry);


                            },
                            editRowStarted: function (evt, ui) {
                                if (ui.rowAdding) {
                                    $("#igUploadOTHER_ibb_fp").click();
                                    // onclick_addFile("#igUploadOTHER_ibb_fp");
                                }
                                else { <%-- // do nothing; regular row is being edited --%>

                                }
                            },
                            editRowEnded: function (evt, ui) {

                                <%-- change add new row's filename col back to blank column --%>
                                //$("#dwFileUpload tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(ctx[0]);
                                $("#gridFiles tr").eq(2).find('td:first-child').text("");

                                if (ui.rowAdding) { <%-- //new row edited --%>
                                    if (!ui.update) {
                                        //do nothing 
                                    }
                                }
                                else { <%-- //regular row is being edited --%>
                                    //call update

                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                    var desc = null;
                                    if (!checkNullOrUndefined(ui.values.DESC)) {
                                        desc = ui.values.DESC;
                                    }
                                    PageMethods.updateFileUploadData(row.FID, desc, onSuccess_updateFileUploadData, onFail_updateFileUploadData);
                                }
                            },
                            columnSettings: [
                                { columnKey: "FNAMEOLD", readOnly: true },
                                { columnKey: "FUPDEL", readOnly: true },
                                { columnKey: "DESC", editorType: "text" },

                            ]
                        },
                    ]
            });

            $("#igUploadOTHER").igUpload({
                autostartupload: true,
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileSelecting: function (evt, ui) { },
                fileSelected: function (evt, ui) { showProgress(); },
                fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                    var ctxVal = [];
                    var MSID = $("#dwFileUpload").data("data-MSID");
                    ctxVal[0] = ui.filePath;
                    ctxVal[1] = "OTHER";
                    ctxVal[2] = MSID;
                    PageMethods.processFileAndData(ui.filePath, "OTHER", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                    hideProgress();
                },
                fileUploadedAborted: function (evt, ui) {
                    hideProgress();
                },
                onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in inspectionNew.aspx, igUploadOTHER"); },

            });

            $("#igUploadIMAGE").igUpload({
                autostartupload: true,
                allowedExtensions: ["tiff", "gif", "bmp", "png", "jpg", "jpeg", "webp", "bpg", "pdf"],
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileExtensionsValidating: function (evt, ui) {
                    var check = ui;
                },
                fileSelected: function (evt, ui) {
                    showProgress();
                },
                fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                    var ctxVal = [];
                    var MSID = $("#igUploadIMAGE").data("MSID");

                    ctxVal[0] = ui.filePath;
                    ctxVal[1] = "IMAGE";
                    ctxVal[2] = MSID;
                    PageMethods.processFileAndData(ui.filePath, "IMAGE", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                    hideProgress();
                    $("#igUploadIMAGE").data("MSID", null);
                },
                fileUploadedAborted: function (evt, ui) {
                    hideProgress();
                },
                onError: function (evt, ui) {
                    $("#igUploadIMAGE").data("MSID", null);
                    hideProgress();
                    if (ui.errorType.toString().contains("clientside") && ui.errorCode === 2) {
                        alert("Invalid file type. Please make sure you are uploading an image.");
                    }
                    else {
                        sendtoErrorPage("Error in inspectionNew.aspx, igUploadImage");
                    }
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

                <%--Document ready calls--%>

            PageMethods.getTruckAndDataAvailableForInspections(onSuccess_getTruckAndDataAvailableForInspections, onFail_getTruckAndDataAvailableForInspections);
            //PageMethods.getListofTrucksCurrentlyInZXP(onSuccess_getListofTrucksCurrentlyInZXP, onFail_getListofTrucksCurrentlyInZXP);
            PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
            PageMethods.getInspectionResultTypes(onSuccess_getInspectionResultTypes, onFail_getInspectionResultTypes);
            hideAtInit(); <%-- hide html components --%>
        }); <%--end of $(function () {--%>

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

    <br />
    <br />

    <div>
        <h2 style="display: inline">Select a PO - Trailer for Inspection</h2>
    </div>
    <div>
        <input id="cboxTruckList" /></div>

    <div id="dvSectionViewTruck" class="dvOutline dvLightGrey">
        <div>
            <h2 class="sectionHeaderStyling">View PO - Trailer Details <span id="spPOTrailer1"></span></h2>
            <div class="dvHideShowButtons">
                <input type="button" id="btn_show_dvSectionViewTruck_Details" onclick="show_dvSectionViewTruck_Details(); return false;" value="Show" /><input type="button" id="btn_hide_dvSectionViewTruck_Details" onclick="    hide_dvSectionViewTruck_Details(); return false;" value="Hide" /></div>
        </div>
        <div id="dvSectionViewTruck_Details">
            <table class="tblTruckDetailsStyle">
                <tr>
                    <td class="col1_of_4" id="">PO:</td>
                    <td class="col2_of_4"><span id="lblPO"></span></td>
                    <td class="col3_of_4">Current Location:</td>
                    <td class="col4_of_4"><span id="lblCurrentLocation"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">Trailer:</td>
                    <td class="col2_of_4"><span id="lblTrailNum"></span></td>
                    <td class="col3_of_4">Current Status:</td>
                    <td class="col4_of_4"><span id="lblStatus"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">ETA:</td>
                    <td class="col2_of_4"><span id="lblETA"></span></td>
                    <td class="col3_of_4">Truck Type:</td>
                    <td class="col4_of_4"><span id="lblTruckType"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">Drop Trailer:</td>
                    <td class="col2_of_4"><span id="lblDrop"></span></td>
                    <td class="col3_of_4">Load Type:</td>
                    <td class="col4_of_4"><span id="lblLoad"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">Rejected:</td>
                    <td class="col2_of_4"><span id="lblisRejected"></span></td>
                    <td class="col3_of_4">
                        <input id="btnRejectTruck" class="rejectTruckButton" type="button" onclick="onclick_redirectToRejectTruck(); return false;" value="Reject Truck" /></td>
                    <td class="col4_of_4"></td>
                </tr>
                <tr>
                    <td class="col1_of_4">Rejected Comment:</td>
                    <td class="col2_of_4"><span id="lblTimeRejected"></span></td>
                    <td colspan="2"><span id="lblRejectTruck"></span></td>
                </tr>
            </table>
        </div>
    </div>
    <br />
    <br />
    <div id="dvSectionUpdateLocationStatus" class="dvOutline dvLightGrey">
        <div>
            <h2 class="sectionHeaderStyling">Update Truck Location <span id="spPOTrailer2"></span></h2>
            <div class="dvHideShowButtons">
                <input type="button" id="btn_show_dvSectionUpdateLocationStatus_Details" onclick="show_dvSectionUpdateLocationStatus_Details(); return false;" value="Show" /><input type="button" id="btn_hide_dvSectionUpdateLocationStatus_Details" onclick="    hide_dvSectionUpdateLocationStatus_Details(); return false;" value="Hide" /></div>
        </div>
        <div>
            <h3 class="sectionHeaderStyling">Update the location to where the truck/trailer is currently being inspected</h3>
        </div>
        <div id="dvSectionUpdateLocationStatus_Details">
            <table class="tblTruckDetailsStyle">
                <tr>
                    <td class="col1_of_2">Current Location:</td>
                    <td class="col2_of_2">
                        <label id="lblLoc" style="color: blue"></label>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">Current Status:</td>
                    <td class="col2_of_2">
                        <label id="lblStat" style="color: blue"></label>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">New Location:</td>
                    <td class="col2_of_2">
                        <div id="dvLocStat" style="display: inline; vertical-align: middle">
                            <div class="dvAlignMid">
                                <input id="cboxLocationStatus" /></div>
                            <div class="dvAlignMid">
                                <input id="btnUpdateLocation" type="button" onclick="onclick_UpdateLocation()" value="Update" /></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">New Dock Spot:</td>
                    <td class="col2_of_2">
                        <div id="dvLocDockSpot" style="display: inline; vertical-align: middle">
                            <div class="dvAlignMid">
                                <input id="cboxDockSpots" /></div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <br />
    <br />
    <div id="dvSectionViewInspectionList" class="dvOutline dvLightGrey">
        <div>
            <h2 class="sectionHeaderStyling">Create or View List of Inspections <span id="spPOTrailer3"></span></h2>
            <div class="dvHideShowButtons">
                <input type="button" id="btn_show_dvSectionViewInspectionList_Details" onclick="show_dvSectionViewInspectionList_Details(); return false;" value="Show" /><input type="button" id="btn_hide_dvSectionViewInspectionList_Details" onclick="    hide_dvSectionViewInspectionList_Details(); return false;" value="Hide" /></div>
        </div>
        <div>
            <h3 id="msgReadOnly" style="color: red; display: none;">Read only, editing is disabled.</h3>
        </div>
        <div id="dvSectionViewInspectionList_Details">
            <table class="tblTruckDetailsStyle">
                <tr>
                    <td class="col1_of_2">Filter Available Lists Based On Products:</td>
                    <td class="col2_of_2">
                        <div id="dvProductInspectionFilter">
                            <input id="cboxProductInspectionFilter" style="max-width: 100%; float: left" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">Select Inspection List: </td>
                    <td class="col2_of_2">
                        <div id="dvInspectionListFilter" class="noDisplay">
                            <div class="dvAlignMid">
                                <input id="cboxInspectionGroupList" /></div>
                            <%--<div class="dvAlignMid"><input id="btnCreateInspectionList" type="button" onclick="onclick_createOrViewListAndInspections(); return false;" value="Create/View List" /></div>--%>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">Create New or View Version:</td>
                    <td class="col2_of_2">
                        <div id="dvInspectionListVersionFilter" class="noDisplay">
                            <div class="dvAlignMid">
                                <input id="cboxInspectionGroupVersionList" /></div>
                            <div class="dvAlignMid">
                                <input id="btnCreateInspectionList" type="button" onclick="onclick_createOrViewListAndInspections(); return false;" value="Create New List" /></div>
                            <div class="dvAlignMid">
                                <input id="btnViewInspectionList" type="button" onclick="onclick_createOrViewListAndInspections(); return false;" value="View Selected List" /></div>
                        </div>
                    </td>

                </tr>
                <tr>
                    <td colspan="2">
                        <label id="lblMsgcreateOrViewListAndInspections" style="color: blue"></label>
                    </td>
                </tr>
            </table>
            <div id="dvInspectionList_InspectionNames" class="noDisplay dvOutline dvLightGrey">
                <h2 class="sectionHeaderStyling">Inspections Under List: <span id="lblSelectedList" style="display: inline"></span><span id="spPOTrailer4" style="display: inline"></span></h2>
                <table id="gridOfInspectionsUnderList" style="width: 100%"></table>
            </div>
            <div id="dvInspectionListData_Details" class="noDisplay dvOutline dvLightGrey">
                <h2 class="sectionHeaderStyling">View All Versions for Inspection: <span id="lblSelectedInspection" style="display: inline"></span><span id="spPOTrailer5" style="display: inline"></span></h2>
                <div>
                    <h3 style="color: red;"><span id="msgResults" style="display: inline"></span></h3>
                </div>
                <div id="dvCreateNewVersion">
                    <div>
                        <h3 style="color: red; display: none;"><span id="msgErrorCreateNewVersion" style="display: inline"></span></h3>
                    </div>
                    <h3 class="sectionHeaderStyling">Add New Version:
                        <button id="btnCreateNewInspectionVersion" class="disableableInspectionButtons" onclick="onclick_CreateNewInspectionVersion()">Create New</button></h3>
                </div>
                <table id="gridOfInspectionVersions" style="width: 100%"></table>
            </div>
        </div>

        <div id="dvSectionViewInspectionTest" class="noDisplay dvOutline dvLightGrey">
            <h2 class="sectionHeaderStyling">Selected Inspection: <span id="lblSelectedVersion" style="display: inline; color: blue"></span></h2>

            <div id="dvComment">
                <div style="display: inline; width: 30%">Inspection Comments:</div>
                <div style="display: inline; width: 70%">
                    <textarea id="txtInspectionComment" style="max-width: 100%; width: 75%; height: 100%" placeholder="Comments:" maxlength="250" required="required"></textarea>
                    <div style="float: right">
                        <input id="btnUpdateInspectionComment" type="button" value="Update Comment" onclick="onclick_UpdateComment()" />
                        <div id="lblCommentUpdated" style="float: left"></div>
                    </div>
                </div>
            </div>
            <div id="dvResults">
                <table id="grid"></table>
            </div>
        </div>
    </div>

    <br />
    <br />
    <br />

    <div id="dvSectionMissingResults" class="dvOutline dvLightGrey" style="width: 100%;">
        <h2 class="sectionHeaderStyling">Trucks with Incomplete Test<span id="Span1"></span></h2>
        <div class="dvHideShowButtons">
            <span id="dvMissingResultsShow">
                <input type="button" id="btn_showMissingResults" onclick="showMissingResults(); return false;" value="Show" /></span>
            <span id="dvMissingResultsHide">
                <input type="button" id="btn_hideMissingResults" onclick="hideMissingResults(); return false;" value="Hide" /></span>
        </div>
        <div id="dvMissingResults">
            <div>
                Filter Grid Results 
                <span id="Div1">
                    <input type="button" onclick="onclick_ShowAllTrucks(); return false;" value="Show All" /><input type="button" onclick="    onclick_ShowTodayOnly(); return false;" value="Show Today Only" /></span>
            </div>
            <table id="gridMissingResults"></table>
        </div>
    </div>
    <%-- dialog for file upload--%>
    <div id="dwFileUpload">
        <h2><span>Files:  <span id="POTrailer_dwFileUpload"></span></span></h2>
        <div class="ContentExtend">
            <table id="gridFiles" class="ContentExtend"></table>
        </div>
    </div>

    <div id="dwProductDetails">
        <h2><span>PO - Trailer:  <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>

    <div id="dvUploadsContainer" style='display: none;'>
        <div id="igUploadOTHER" style='display: none;'></div>
        <input type="file" style='display: none;' id="igUploadIMAGE" class="CameraUpload" accept="image/*" capture='camera'>
    </div>

</asp:Content>