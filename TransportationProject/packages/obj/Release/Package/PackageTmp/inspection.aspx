<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="inspection.aspx.cs" Inherits="TransportationProject.inspection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
    <h2>Inspections</h2>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">
        //1= yes, 2=no, 3 = null 
        //TODO remove prefilled global values
        // var GLOBAL_INSPECTION_DATA = [];
        var GLOBAL_POID = 123;
        var GLOBAL_PO;
        var GLOBAL_INSPECTIONTYPE = "MT";
        var GLOBAL_TRUCK_DATA = [];
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_INSPECTION_OPTIONS = [];
        var GLOBAL_PRODUCT_OPTIONS = [];

        <%----%>
        <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>


        Number.prototype.padLeft = function (base, chr) {
            var len = (String(base || 10).length - String(this).length) + 1;
            return len > 0 ? new Array(len).join(chr || '0') + this : this;
        }

        function radioFormatter(val) {
            return "<input class= 'radButtonLarger' style='width:100%; margin: 0px;'  type='radio' " + (val === true ? "checked='checked'" : '') + " />";
        }

        function boolYesNoFormatter(val) {
            if (val) {
                return "YES"
            }
            else {
                return "NO"
            }
        }

        //function shouldEnableLocStatDropDown(val) {
        //    if (val === "GSI" || val === "INSPECT") {
        //        return true;
        //    }
        //    return false;
        //}

        <%-------------------------------------------------------
         Button Click Handlers
         -------------------------------------------------------%>

        function hideAtInit() {
            $("#trProductInspectionFilter").hide();
            
            $("#trCreate").hide();
            $("#dvTruckDetails").hide();
            
            $("#dvTrailerInspections").hide();
            $("#dvResults").hide();

            $("#trInspectionActions").hide();
            $("#dvInspectionActionsStart").hide();
            $("#dvInspectionActionsEnd").hide();
            $("#dvInspectionActionsUpdate").hide();
            $("#dvDeleteInspections").hide();
            $("input:radio").attr("disabled", true);

            $("#dvMissingResultsHide").show();
            $("#dvMissingResults").show();
            $("#dvMissingResultsShow").hide();


            $("#dvLocStat").hide();
            $("#dvLocStatDisabled").hide();
        }
        function showMissingResults() {
            $("#dvMissingResultsHide").show();
            $("#dvMissingResults").show();
            $("#dvMissingResultsShow").hide();
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
        }
        function hideMissingResults() {
            $("#dvMissingResultsHide").hide();
            $("#dvMissingResults").hide();
            $("#dvMissingResultsShow").show();
        }
        function displayNotStartedInspectionItems() { //show start button, show delete inspection button, hide and disable table
            $("#dvInspectionActionsStart").show();
            $("#dvInspectionActionsEnd").hide();
            $("#dvInspectionActionsUpdate").hide();
            $("#dvDeleteInspections").show();
            $("#grid").igGridUpdating("option", "editMode", "none");
            $("input:radio").attr("disabled", true);
            $("#dvResults").hide(); 
            $('#lblInspLastStartOpen').text("");
            $('#lblInspLastFin').text("");
        }

        function displayStartedInspectionItems() { //show end button, show delete, enable and show table
            $("#dvInspectionActionsStart").hide();
            $("#dvInspectionActionsEnd").show();
            $("#dvInspectionActionsUpdate").hide();
            $("#dvDeleteInspections").show();
            $("#grid").igGridUpdating("option", "editMode", "row");
            $("input:radio").attr("disabled", false);
            $("#dvResults").show();
        }
        function displayEndedInspectionItems() { //show reopen button, show delete, disable and show table
            $("#dvInspectionActionsStart").hide();
            $("#dvInspectionActionsEnd").hide();
            $("#dvInspectionActionsUpdate").show();
            $("#dvDeleteInspections").show();
            $("#grid").igGridUpdating("option", "editMode", "none");
            $("input:radio").attr("disabled", true);
            $("#dvResults").show();
        }
        function displayStartedButNotEndedItems() {//sts

            $("#dvInspectionActionsStart").hide();
            $("#dvInspectionActionsEnd").show();
            $("#dvInspectionActionsUpdate").hide();
            $("#btnDeleteInspection").hide();
            $("#dvResults").show();

        }
        function viewOnlyMode() {//sts
            var inspectionItems = $("#cboxCurrentInspectionsList").igCombo("selectedItems");
            $("#dvInspectionActionsStart").hide();
            $("#dvInspectionActionsEnd").hide();
            $("#dvInspectionActionsUpdate").hide();
            $("#dvDeleteInspections").hide();
            $("#grid").igGridUpdating("option", "editMode", "none");
            $("input:radio").attr("disabled", true);
            $("#txtInspectionComment").attr("disabled", true);
            $("#txtInspectionComment").attr("readonly", true);
            $("#msgReadOnlyOnRejected").show();

            if (GLOBAL_INSPECTION_OPTIONS.length > 0) { 
                if (GLOBAL_INSPECTION_OPTIONS[0].INSPID == -1) {
                    var currentInspection = $("#cboxCurrentInspectionsList").igCombo("value");
                    GLOBAL_INSPECTION_OPTIONS.shift();
                    $("#cboxCurrentInspectionsList").igCombo("option", "dataSource", GLOBAL_INSPECTION_OPTIONS);
                    $("#cboxCurrentInspectionsList").igCombo("dataBind");
                    $("#cboxCurrentInspectionsList").igCombo("value", currentInspection);
                }
            }
            if (checkNullOrUndefined(inspectionItems) === false) {<%--if rejecting truck while not viewing inspection, do not show dvResults otherwise show--%>
                $("#dvResults").show();
            }

        }

        function onclick_ViewTruck() {

            $("#trInspectionActions").hide();
            $("#trComment").hide();

            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            if (msidItems) {
                var MSID = msidItems[0].data.MSID;
                //var pad = "00";

                var loc = $("#cboxTruckList").data("data-loc");
                var stat = $("#cboxTruckList").data("data-stat");

                for (i = 0; i < GLOBAL_TRUCK_DATA.length; i++) {
                    if (GLOBAL_TRUCK_DATA[i].MSID === MSID) {
                        if (GLOBAL_TRUCK_DATA[i].REJECT) {
                            $("#grid").data("data-isRejected", true);//r3j
                            $("#grid").igGridUpdating("option", "editMode", "none");
                            $("input:radio").attr("disabled", true);
                            $("#btnUpdateInspectionComment").hide();
                            $("#txtInspectionComment").attr("disabled", true);
                            $("#txtInspectionComment").attr("readonly", true);
                            $("#msgReadOnlyOnRejected").show();

                        }
                        else {
                            $("#grid").data("data-isRejected", false);
                            $("#btnUpdateInspectionComment").show();
                            $("#txtInspectionComment").attr("disabled", false);
                            $("#txtInspectionComment").attr("readonly", false);
                            //$("#lblRejectTime").text("");
                            if (stat != '8' && stat != '9' && stat != '11' && stat != '12' && stat != '13' && stat != '14' && loc != 'GS' && loc != 'NOS' && loc != 'LAB') {
                                $("#msgReadOnlyOnRejected").hide();
                            }
                        }
                        
                        $("#lblviewAddToPO").text("PO: " + $.trim(String(GLOBAL_TRUCK_DATA[i].PO)) + ", Trailer#: " + $.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));
                        $("#dvTrailerInspections").show();

                        PageMethods.getCurrentInspectionsForAnMSID(msidItems[0].data.MSID, onSuccess_getCurrentInspectionsForAnMSID, onFail_getCurrentInspectionsForAnMSID);
                    }
                }
            }
        }

        function onclick_UpdateComment(){
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionItems = $("#cboxCurrentInspectionsList").igCombo("selectedItems");
            if (msidItems && inspectionItems) {
                var MSID = msidItems[0].data.MSID;
                var inspectionID = inspectionItems[0].data.INSPID;

                var placeholdertext = $("#txtInspectionComment").attr("placeholder");
                var comment = $("#txtInspectionComment").val().replace(placeholdertext, "");
                    PageMethods.updateInspectionComment(MSID, inspectionID, comment, onSuccess_updateInspectionComment, onFail_updateInspectionComment)
            }


        }

        function onclick_UpdateLocation() {
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var locstatItems = $("#cboxLocationStatus").igCombo("selectedItems");
            if (msidItems && locstatItems) {
                var MSID = msidItems[0].data.MSID;
                var locstat = locstatItems[0].data.LOCSTAT;

                PageMethods.updateLocation(MSID, locstat, onSuccess_updateLocation, onFail_updateLocation, locstatItems[0].data);
                //PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);

            }
        }

        function onclick_CreateNewInspection() {

            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionItems = $("#cboxAvailableInspectionsList").igCombo("selectedItems");
            if (msidItems && inspectionItems) {
                //if (msidItems) {
                var MSID = msidItems[0].data.MSID;
                var inspectionID = inspectionItems[0].data.INSPID;
                //alert(MSID + " " + headerID);
                //ctxVal = [];
                //ctxVal[0] = MSID;
                // ctxVal[1] = inspectionID;

                PageMethods.createNewInspection(MSID, inspectionID, onSuccess_createNewInspection, onFail_createNewInspection, MSID);
            }
        }

        function onclick_StartInspection() {
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionItems = $("#cboxCurrentInspectionsList").igCombo("selectedItems");
            if (msidItems && inspectionItems) {
                var MSID = msidItems[0].data.MSID;
                var inspectionID = inspectionItems[0].data.INSPID;

                PageMethods.startInspection(MSID, inspectionID, onSuccess_startInspection, onFail_startInspection);
                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
            }

        }
        function onclick_EndInspection() {
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionItems = $("#cboxCurrentInspectionsList").igCombo("selectedItems");
            if (msidItems && inspectionItems) {
                var MSID = msidItems[0].data.MSID;
                var inspectionID = inspectionItems[0].data.INSPID;

                PageMethods.endInspection(MSID, inspectionID, onSuccess_endInspection, onFail_endInspection);
            }

        }
        function onclick_ReopenAndUpdateInspection() {
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionItems = $("#cboxCurrentInspectionsList").igCombo("selectedItems");
            if (msidItems && inspectionItems) {
                var MSID = msidItems[0].data.MSID;
                var inspectionID = inspectionItems[0].data.INSPID;

                PageMethods.reopenInspection(MSID, inspectionID, onSuccess_reopenInspection, onFail_reopenInspection);
                PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
            }

        }

        function onclick_DeleteInspection() {
            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            var inspectionItems = $("#cboxCurrentInspectionsList").igCombo("selectedItems");
            if (msidItems && inspectionItems) {
                var MSID = msidItems[0].data.MSID;
                var inspectionID = inspectionItems[0].data.INSPID;

                var r = confirm("Continue deleting inspection? Deletion cannot be undone.");
                if (r == true) {
                    PageMethods.deleteInspection(MSID, inspectionID, onSuccess_deleteInspection, onFail_deleteInspection);
                    PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                }

            }
        }

        //function onclick_RejectTruck() {
        //    var msidItems = $("#cboxTruckList").igCombo("selectedItems");
        //    if (msidItems) {
        //        var MSID = msidItems[0].data.MSID;

        //        var placeholdertext = $("#txtRejectTruck").attr("placeholder");
        //        var comment = $("#txtRejectTruck").val().replace(placeholdertext, "");
        //        if (!checkNullOrUndefined(comment)) {

        //            var r = confirm("Are you sure you want to reject the truck?");
        //            if (r == true) {
        //                PageMethods.rejectTruck(MSID, comment, onSuccess_rejectTruck, onFail_rejectTruck);

        //            }
        //        }
        //        else {
        //            alert("Please enter a reason for rejecting truck.");
        //        }

        //    }
        //}
        //function onclick_UndoRejectTruck() {
        //    var msidItems = $("#cboxTruckList").igCombo("selectedItems");
        //    if (msidItems) {
        //        var MSID = msidItems[0].data.MSID;

        //        var r = confirm("Are you sure you want to continue to undo?");
        //        if (r == true) {
        //            PageMethods.undoRejectTruck(MSID, onSuccess_undoRejectTruck, onFail_undoRejectTruck);
        //        }
        //    }
        //}


        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>


        function onSuccess_getLocationOptions(returnValue, ctx, methodName) {
            GLOBAL_LOCATION_OPTIONS = [];

            for (i = 1; i < returnValue.length; i++) { //start at one to not add current location
                GLOBAL_LOCATION_OPTIONS.push({ "LOC": returnValue[i][0], "LOCTEXT": returnValue[i][1] });
            }

            $("#cboxLocations").igCombo("option", "dataSource", GLOBAL_LOCATION_OPTIONS);
            $("#cboxLocations").igCombo("dataBind");

            //set current location on label 
            if (returnValue[0][0] == 'GS') {
                $("#lblLocation").html("Current Location: Guard Station  (NOTE: Inspctions can not be done in Guard Station)");
            }
            else {
                $("#lblLocation").html("Current Location: " + returnValue[0][1]);
                $("#cboxLocations").igCombo("value", returnValue[0][0]);
            }

        }

        function onFail_getLocationOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in Samples.aspx, onFail_getLocationOptions");
        }
        function onSuccess_updateInspectionComment(value, ctx, methodName) {
            <%-- add code as needed --%>
            $('#lblCommentUpdated').text("Comment Updated");
            $("#lblCommentUpdated").fadeIn(1500);
            $('#lblCommentUpdated').text("");

        }

        function onFail_updateInspectionComment(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_updateInspectionComment");
        }

        function onSuccess_updateLocation(value, newStatus, methodName) {
            $("#lblLocStat").text("Current Location: " + $.trim(newStatus.LOCSTATTEXT) + ", Status: Waiting");


            $("#cboxTruckList").data("data-loc", $.trim(newStatus.LOCSTAT));
            $("#cboxTruckList").data("data-stat", 5); //waiting


            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            if (msidItems) {
                var MSID = msidItems[0].data.MSID;
                for (i = 0; i < GLOBAL_TRUCK_DATA.length; i++) {
                    if (GLOBAL_TRUCK_DATA[i].MSID === MSID) {
                        GLOBAL_TRUCK_DATA[i].LOCLONG = newStatus.LOCSTATTEXT;
                        GLOBAL_TRUCK_DATA[i].LOCSHORT = newStatus.LOCSTAT;
                    }
                }
            }

            //the status can only be updated to a valid status so...
            $("#cboxTruckList").data("data-isAbleToInspect", true);

           // $("#dvLocStat").hide();
            //$("#dvLocStatDisabled").show();
            //if (newStatus.LOCSTAT == 'INSPECT') {
            //    $("#cboxTruckList").data("data-isInspecting", true);
                
            //        var currentStatus = $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus");
            //        switch (currentStatus) {
            //            case 'NotStarted':
            //                displayNotStartedInspectionItems();
            //                break;
            //            case 'Started':
            //                displayStartedInspectionItems();
            //                break;
            //            case 'Ended':
            //                displayEndedInspectionItems();
            //                break;
            //            case null:
            //                break;
            //        }
                
            //}
            //else {
            //    $("#cboxTruckList").data("data-isInspecting", false);
            //    viewOnlyMode();
            //}

        //    if (newStatus.LOCSTAT == 'INSPECT' || newStatus.LOCSTAT == 'GSI') {<%--if status can be changed from this view, update options--%>
                //PageMethods.getAvailableLocationStatus(msidItems[0].data.MSID, onSuccess_getAvailableLocationStatus, onFail_getAvailableLocationStatus);
          //  }
          //  else {<%--else hide combo box and only display on label--%>
            //    $("#dvLocStat").hide();
            //    //$("#lblLocStat").text(newStatus.LOCSTATTEXT);
            //    $("#dvLocStatDisabled").show();
            //}
           
            <%--re-pop truck log--%>
            var selectedTruck = $("#cboxTruckList").igCombo("selectedItems");
            PageMethods.getLogDataByMSID(selectedTruck[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, selectedTruck[0].data.MSID);
            var currentInspection = $("#cboxCurrentInspectionsList").igCombo("value");
            if (checkNullOrUndefined(currentInspection) == true) {
                PageMethods.getCurrentInspectionsForAnMSID(selectedTruck[0].data.MSID, onSuccess_getCurrentInspectionsForAnMSID, onFail_getCurrentInspectionsForAnMSID);
            }
            else {
                PageMethods.getCurrentInspectionsForAnMSID(selectedTruck[0].data.MSID, onSuccess_getCurrentInspectionsForAnMSIDwSetVal, onFail_getCurrentInspectionsForAnMSID, currentInspection);
            }
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
        }
        function onFail_updateLocation(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_updateLocation");
        }


        function onSuccess_createNewInspection(value, ctx, methodName) {
            $("#trProductInspectionFilter").hide();
            $("#trCreate").hide();
            // $("#dvDeleteInspections").show();
            displayNotStartedInspectionItems();
            $("#trInspectionActions").show();

            var MSID = ctx;
            var inspectionID = value;

            PageMethods.getCurrentInspectionsForAnMSID(MSID, onSuccess_getCurrentInspectionsForAnMSIDwSetVal, onFail_getCurrentInspectionsForAnMSID, inspectionID);
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
        }
        function onFail_createNewInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_createNewInspection");
        }

        function onSuccess_deleteInspection(value, ctx, methodName) {
            // $("#dvDeleteInspections").hide();

            $("#trInspectionActions").hide();
            $("#dvResults").hide();

            var msidItems = $("#cboxTruckList").igCombo("selectedItems");
            if (msidItems) {
                var MSID = msidItems[0].data.MSID;
                PageMethods.getCurrentInspectionsForAnMSID(MSID, onSuccess_getCurrentInspectionsForAnMSID, onFail_getCurrentInspectionsForAnMSID);
            }
        }
        function onFail_deleteInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_deleteInspection");

        }
        function onSuccess_startInspection(startTime, ctx, methodName) {
            if (startTime) {
                var sDate = new Date(startTime);
                $("#lblInspLastStartOpen").text((1 + sDate.getMonth()).toString() + "/" + sDate.getDate().toString() + "/" + sDate.getFullYear().toString() + " " + ("00" + sDate.getHours()).slice(-2) + ":" + ("00" + sDate.getMinutes()).slice(-2));
            }
            var selectedTruck = $("#cboxTruckList").igCombo("selectedItems");
            PageMethods.getLogDataByMSID(selectedTruck[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, selectedTruck[0].data.MSID);
            displayStartedInspectionItems();
        }
        function onFail_startInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_startInspection");

        }
        function onSuccess_endInspection(value, ctx, methodName) {
            if (value) {
                var sDate = new Date(value);
                $("#lblInspLastFin").text((1 + sDate.getMonth()).toString() + "/" + sDate.getDate().toString() + "/" + sDate.getFullYear().toString() + " " + ("00" + sDate.getHours()).slice(-2) + ":" + ("00" + sDate.getMinutes()).slice(-2));
            }
            var selectedTruck = $("#cboxTruckList").igCombo("selectedItems");
            PageMethods.getLogDataByMSID(selectedTruck[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, selectedTruck[0].data.MSID);
            displayEndedInspectionItems();
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
        }
        function onFail_endInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_endInspection");

        }
        function onSuccess_reopenInspection(value, ctx, methodName) {
            var selectedTruck = $("#cboxTruckList").igCombo("selectedItems");
            PageMethods.getLogDataByMSID(selectedTruck[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, selectedTruck[0].data.MSID);
            $("#lblInspLastFin").text("");
            displayStartedInspectionItems();
        }
        function onFail_reopenInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_reopenInspection");

        }

        function onSuccess_getInspectionDetails(value, ctx, methodName) {
            var hasInspectionStarted = $("#grid").data("data-inspectionHasStarted");
            var isRejected = $("#grid").data("data-isRejected");
            var isAbleToInspect = $("#cboxTruckList").data("data-isAbleToInspect");
            //var isInspecting = $("#cboxTruckList").data("data-isInspecting");
            if (value && value.length > 0) {
                var startEventID = value[0][0];
                var startTime = value[0][1];
                var endEventID = value[0][2];
                var endTime = value[0][3];
                var inspectionComments = value[0][4];

                if (!checkNullOrUndefined(inspectionComments)) {
                    $("#txtInspectionComment").val(inspectionComments);
                }
                else {
                    var placeholdertext = $("#txtInspectionComment").attr("placeholder");
                    $("#txtInspectionComment").val(placeholdertext);
                }

                if (!checkNullOrUndefined(startTime)) {
                    var sDate = new Date(startTime);
                    //var monVal = 1 + sDate.getMonth();
                    $("#lblInspLastStartOpen").text((1 + sDate.getMonth()).toString() + "/" + sDate.getDate().toString() + "/" + sDate.getFullYear().toString() + " " + ("00" + sDate.getHours()).slice(-2)+ ":" + ("00" + sDate.getMinutes()).slice(-2));
                }
                else {
                    $("#lblInspLastStartOpen").text("");
                }
                if (!checkNullOrUndefined(endTime)) {
                    var eDate = new Date(endTime);
                    //var monVal = 1 + eDate.getMonth();
                    $("#lblInspLastFin").text((1 + eDate.getMonth()).toString() + "/" + eDate.getDate().toString() + "/" + eDate.getFullYear().toString() + " " + ("00" + eDate.getHours()).slice(-2) + ":" + ("00" + eDate.getMinutes()).slice(-2));
                }
                else {
                    $("#lblInspLastFin").text("");
                }

                if (checkNullOrUndefined(startTime)) {//inspection not started
                    $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", "NotStarted");
                    if (isRejected == true || isAbleToInspect == false) {
                        viewOnlyMode();
                    }
                    else {
                        displayNotStartedInspectionItems();
                    }
                }
                else if (!checkNullOrUndefined(startTime) && checkNullOrUndefined(endTime)) {  //inspection not ended
                    $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", "Started");
                    if (isRejected == true || isAbleToInspect == false) {
                        viewOnlyMode();
                    }
                    else {
                        displayStartedInspectionItems();
                    }
                }
                else if (!checkNullOrUndefined(startTime) && !checkNullOrUndefined(endTime)) {//inspection ended 
                    $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", "Ended");
                    if (isRejected == true || isAbleToInspect == false) {
                        viewOnlyMode();
                    }
                    else {
                        displayEndedInspectionItems();
                    }
                }
            }
            else if (value.length === 0 && (hasInspectionStarted === false || checkNullOrUndefined(hasInspectionStarted) == true)) {//for new inspection
                //$("#trInspectionActions").hide();
                //$("#grid").igGridUpdating("option", "editMode", "none");

                var placeholdertext = $("#txtInspectionComment").attr("placeholder");
                $("#txtInspectionComment").val(placeholdertext);
                $("#lblInspLastStartOpen").text("");
                $("#lblInspLastFin").text("");


                $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", "NotStarted");
                if (isRejected == true || isAbleToInspect == false) {
                    viewOnlyMode();
                }
                else {
                    displayNotStartedInspectionItems();
                }
            }
            else if (value.length === 0 && hasInspectionStarted === true) {// for previously open but not finished inspections
                $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", "Started");
                if (isRejected == true || isAbleToInspect == false) {
                    viewOnlyMode();
                }
                else {
                    displayStartedButNotEndedItems();
                }
            }
            //else if (value.length === 0 && (isRejected == true))//view only
            //{
            //  $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", "REJECTED?");
            //    viewOnlyMode();
            //}



            //else if (value.length === 0 && (hasInspectionStarted === false || checkNullOrUndefined(hasInspectionStarted) == true)) {
            //    //$("#trInspectionActions").hide();
            //    //$("#grid").igGridUpdating("option", "editMode", "none");
            //    displayNotStartedInspectionItems();
            //}
            //else if (value.length === 0 & hasInspectionStarted === true) {
            //    //inspection startedasas
            //}
        }

        function onFail_getInspectionDetails(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getInspectionDetails");

        }

        function onSuccess_getInspectionGridData(value, ctx, methodName) {
            //GLOBAL_INSPECTION_DATA.length = 0 <%--make empty--%>
            var gridData = [];
            gridData.length = 0;
            $("#grid").data("data-inspectionHasStarted", false);

            for (i = 0; i < value.length; i++) {
                var vPass = false, vFail = false, vNA = false;
                if (1 === value[i][2]) { //pass
                    vPass = true;
                    vFail = false;
                    vNA = false;
                    $("#grid").data("data-inspectionHasStarted", true);
                }
                else if (0 === value[i][2]) { //fail
                    vFail = true;
                    vPass = false;
                    vNA = false;
                    $("#grid").data("data-inspectionHasStarted", true);
                }
                else if (-1 === value[i][2]) { //not applicable
                    vPass = false;
                    vFail = false;
                    vNA = true;
                    $("#grid").data("data-inspectionHasStarted", true);
                }

                gridData[i] = {
                    "INSPID": value[i][0], "TESTID": value[i][1], "RESULT": value[i][2], "TIMESTAMP": value[i][3], "USERID": value[i][4],
                    "COMMENT": value[i][5], "TESTDESC": value[i][6], "PASS": vPass, "FAIL": vFail, "NA": vNA
                }
            }
            $("#grid").igGrid("option", "dataSource", gridData);
            $("#grid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
            if (ctx) {
                var inspectionID = ctx;
                PageMethods.getInspectionDetails(ctx, onSuccess_getInspectionDetails, onFail_getInspectionDetails);
            }
        }

        function onFail_getInspectionGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getInspectionGridData");
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
                gridData[i] = {

                    "MSID": value[i][0], "ETA": value[i][1], "PONUM": value[i][2], "TRAILNUM": value[i][3], "INSP": value[i][4], "LOCSTAT": value[i][5],
                    "LOCLONG": value[i][6], "INSPCLOSED": isInspectionComplete, "REJECTED": rejected, "REJECTEDTEXT": rejectedText
                };
            }

            $("#gridMissingResults").igGrid("option", "dataSource", gridData);
            $("#gridMissingResults").igGrid("dataBind");
        }
        function onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest");
        }

        function onSuccess_getAvailableLocations(value, ctx, methodName) {

            var cboxData = [];
            cboxData.length = 0;
            for (i = 0; i < value.length; i++) {
                cboxData[i] = { "LOCSTAT": value[i][0], "LOCSTATTEXT": value[i][1] };
            }
            $("#cboxLocationStatus").igCombo("option", "dataSource", cboxData);
            $("#cboxLocationStatus").igCombo("dataBind");
            //$("#cboxLocationStatus").igCombo("option", "mode", "readonly");

        }
        function onFail_getAvailableLocations(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getAvailableLocations");
        }
        
        function onSuccess_getCurrentLocationAndStatus(currentLocStatus, MSID, methodName) {
            var locShort = currentLocStatus[0];
            var statShort = currentLocStatus[1];
            var locLong = currentLocStatus[2];
            var statLong = currentLocStatus[3];
            var canUpdateStatus = currentLocStatus[4];
            var canEditTest = currentLocStatus[5];
            $("#cboxTruckList").data("data-loc", locShort);
            $("#cboxTruckList").data("data-stat", statShort);            


            if (canUpdateStatus)
            {
                $("#dvSectionUpdateTruck").show();
                $("#dvLocStat").show();
                $("#dvLocStatDisabled").show();
                $("#cboxLocationStatus").igCombo("value", locShort);
                $("#lblLocStat").text("Current Location: " + locLong + ", Status: " + statLong );

            }
            else 
            {  
                $("#dvSectionUpdateTruck").show();
                $("#dvLocStatDisabled").show();
                $("#dvLocStat").hide();
                $("#lblLocStat").text("Current Location: " + locLong + ", Status: " + statLong + "(Currently not eligible for location update)");
            }

            if (!canEditTest)
            {
                viewOnlyMode();
            }

        }
        function onFail_getCurrentLocationAndStatus(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getCurrentLocationAndStatus");
        }

        function onSuccess_getListofTrucksCurrentlyInZXP(value, ctx, methodName) {

            var cboxData = [];
            cboxData.length = 0;
            for (i = 0; i < value.length; i++) {
                cboxData[i] = { "MSID": value[i][0], "PO": String(value[i][4]) + "-" + $.trim(value[i][6]) }; <%-- //Use MSID for ID, and PONumber for Label --%>
            }
            $("#cboxTruckList").igCombo("option", "dataSource", cboxData);
            $("#cboxTruckList").igCombo("dataBind");

            <%--//Trucks Data--%>
            GLOBAL_TRUCK_DATA.length = 0;
            for (i = 0; i < value.length; i++) {

                GLOBAL_TRUCK_DATA[i] = {
                    "MSID": value[i][0], "ETA": value[i][1], "CUSTID": value[i][2], "TRUCKTYPE": value[i][3], "PO": value[i][4], "LOADSHORT": value[i][5], "TRAILNUM": value[i][6],
                    "DROP": value[i][7], "CABIN": value[i][8], "CABOUT": value[i][9], "CARRIER": value[i][10], "SHIP": value[i][11], "LOAD": value[i][12],
                    "REJECT": value[i][13], "REJECTREASON": value[i][14], "LOCLONG": value[i][15], "LOCSHORT": value[i][16], "STATUSID": value[i][17], "TIMEREJECTED": value[i][18]
                }; <%-- //Use MSID for ID, and PONumber for Label --%>
            }
            PageMethods.getAvailableLocations(onSuccess_getAvailableLocations, onFail_getAvailableLocations);
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
        }


        function onFail_getListofTrucksCurrentlyInZXP(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getListofTrucksCurrentlyInZXP");
        }

        function onSuccess_getCurrentInspectionsForAnMSID(value, ctx, methodName) {
            GLOBAL_INSPECTION_OPTIONS = [];
            var isRejected = $("#grid").data("data-isRejected");
            var isAbleToInspect = $("#cboxTruckList").data("data-isAbleToInspect");
            //var isInspecting = $("#cboxTruckList").data("data-isInspecting");
            for (i = 0; i < value.length; i++) {
                GLOBAL_INSPECTION_OPTIONS.push({ "INSPID": value[i][0], "INSPNAME": value[i][4] });
            }

            if ((checkNullOrUndefined(isRejected) == true || isRejected == false) && (isAbleToInspect == true)) {
                GLOBAL_INSPECTION_OPTIONS.unshift({ "INSPID": -1, "INSPNAME": "Create New Inspection" });
            }


            $("#cboxCurrentInspectionsList").igCombo("option", "dataSource", GLOBAL_INSPECTION_OPTIONS);
            $("#cboxCurrentInspectionsList").igCombo("dataBind");

        }
        function onSuccess_getCurrentInspectionsForAnMSIDwSetVal(value, ctx, methodName) {
         

            GLOBAL_INSPECTION_OPTIONS = [];
            var isRejected = $("#grid").data("data-isRejected");
            var isAbleToInspect = $("#cboxTruckList").data("data-isAbleToInspect");
            //var isInspecting = $("#cboxTruckList").data("data-isInspecting");
            for (i = 0; i < value.length; i++) {
                GLOBAL_INSPECTION_OPTIONS.push({ "INSPID": value[i][0], "INSPNAME": value[i][4] });
            }

            if ((checkNullOrUndefined(isRejected) == true || isRejected == false) && (isAbleToInspect == true)) {
                GLOBAL_INSPECTION_OPTIONS.unshift({ "INSPID": -1, "INSPNAME": "Create New Inspection" });
            }


            var inspectionID = ctx;

            <%-- rebind and set to newly created inspection --%>
            $("#cboxCurrentInspectionsList").igCombo("option", "dataSource", GLOBAL_INSPECTION_OPTIONS);
            $("#cboxCurrentInspectionsList").igCombo("dataBind");
            $("#cboxCurrentInspectionsList").igCombo("value", inspectionID);

            PageMethods.getInspectionGridData(inspectionID, onSuccess_getInspectionGridData, onFail_getInspectionGridData, inspectionID);

        }

        function onFail_getCurrentInspectionsForAnMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getCurrentInspectionsForAnMSID");
        }


        function onSuccess_getAvailableNewInspectionsForAnMSID_AllProducts(value, ctx, methodName) {
            var cboxData = [];
            cboxData.length = 0;

            for (i = 0; i < value.length; i++) {
                cboxData[i] = { "INSPID": value[i][0], "INSPNAME": value[i][1], "SORTORDER": value[i][2]};
            }
            $("#cboxAvailableInspectionsList").igCombo("option", "dataSource", cboxData);
            $("#cboxAvailableInspectionsList").igCombo("dataBind");
            $("#trCreate").show();
        }
        function onFail_getAvailableNewInspectionsForAnMSID_AllProducts(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getAvailableNewInspectionsForAnMSID_AllProducts");
        }

        function onSuccess_getAvailableNewInspectionsForAnMSID_OneProducts(value, ctx, methodName) {
            var cboxData = [];
            cboxData.length = 0;

            for (i = 0; i < value.length; i++) {
                cboxData[i] = { "INSPID": value[i][0], "INSPNAME": value[i][1], "SORTORDER": value[i][2] };
            }
            $("#cboxAvailableInspectionsList").igCombo("option", "dataSource", cboxData);
            $("#cboxAvailableInspectionsList").igCombo("dataBind");
            $("#trCreate").show();
        }
        function onFail_getAvailableNewInspectionsForAnMSID_OneProducts(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getAvailableNewInspectionsForAnMSID_OneProducts");
        }

        function onSuccess_setInspectionResult(value, ctx, methodName) {
            var rowID = ctx;
            if (value) {

               
                var ds = $("#grid").igGrid("option", "dataSource");
                var newMonth = ( "00" + (1 + value.getMonth()) ).slice(-2);
                var newDay =  ( "00" + value.getDate()).slice(-2);
                var newTimeStampString = ( newMonth + '/' + newDay + '/' + value.getFullYear()) + " " + getNewTime(value)
              //  var newTimeStamp = new Date(((1 + value.getMonth()) + '/' + value.getDate() + '/' + value.getFullYear()) + " " + getNewTime(value));
                var newTimeStamp = new Date(newTimeStampString);
                //var timeEditor = $("#grid").igGridUpdating("editorForKey", "TIMESTAMP");
                //if (timeEditor) {
                //    timeEditor.igEditor("value", newTimeStamp.toUTCString());
                //}


                $("#grid").data("igGrid").dataSource.setCellValue(rowID, "TIMESTAMP", newTimeStamp, true);
                $("#grid").igGrid("cellById", rowID, "TIMESTAMP").text(newTimeStampString);


              //  $("#grid").igGridUpdating("setCellValue", rowID, "TIMESTAMP", newTimeStamp);
               // $("#grid").igGrid("commit");
            }

            //WORKING - But jumps on screen
            var inspID = ctx;
            //if (inspID) {
            //    PageMethods.getInspectionGridData(inspID, onSuccess_getInspectionGridData, onFail_getInspectionGridData, inspID);
            //}
        }
        function onFail_setInspectionResult(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_setInspectionResult");
        }


        //xxx
        function onSuccess_getLogDataByMSID(value, ctx, methodName) {
            if (value.length > 0) {
                <%--clears Div incase this is not the first table render--%>
                $("#tableLog").empty(); //formally logTableWrapper
                <%-- gets div--%>
                var logDiv = document.getElementById("tableLog");
                <%-- creates table and table body and sets attributes for table--%>
                var tbl = document.createElement('table');
                tbl.style.width = '100%';
                tbl.setAttribute('border', '1');
                var tblBody = document.createElement("tbody");


                for (var i = 0; i < value.length; i++) {
                    <%-- creates row and both cells (one for event time and another for event details--%>
                    var row = document.createElement('tr');
                    var cellTS = document.createElement("td");
                    var cellET = document.createElement("td");
                    var cellFN = document.createElement("td");

                    <%--format time of event--%>
                    var newDateTime = formatDate(value[i][0]);

                    <%--sets cell text--%>
                    var cellTSText = document.createTextNode(newDateTime);
                    var cellETText = document.createTextNode(value[i][1]);
                    var cellFNText = document.createTextNode(value[i][2]);

                    <%-- sets cell text to each cell & append cell to row--%>
                    cellTS.appendChild(cellTSText);
                    row.appendChild(cellTS);

                    cellET.appendChild(cellETText);
                    row.appendChild(cellET);

                    cellFN.appendChild(cellFNText);
                    row.appendChild(cellFN);
                    <%-- appends row to table body--%>
                    tblBody.appendChild(row);
                }
                <%-- appends table body to table--%>
                tbl.appendChild(tblBody);

                <%--appends table to log div--%>
                logDiv.appendChild(tbl);
                $("#cboxLogTruckList").igCombo("value", ctx);

            }
        }

        function onFail_getLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx onFail_getLogDataByMSID");
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
            sendtoErrorPage("Error in inspection.aspx onFail_getLogList");
        }




        function onSuccess_getProductsByMSID(products, ctx, methodName) {
            GLOBAL_PRODUCT_OPTIONS = [];
            for (i = 0; i < products.length; i++) {
                GLOBAL_PRODUCT_OPTIONS.push({ "PRODID": products[i][0], "PRODNAME": products[i][1] });
            }

            GLOBAL_PRODUCT_OPTIONS.unshift({ "PRODID": -1, "PRODNAME": "All Products" });

            $("#cboxProductInspectionFilter").igCombo("option", "dataSource", GLOBAL_PRODUCT_OPTIONS);
            $("#cboxProductInspectionFilter").igCombo("dataBind");
            $("#trProductInspectionFilter").show();
            $("#cboxProductInspectionFilter").igCombo("value", -1);
            var MSID = $("#cboxTruckList").igCombo("selectedItems")[0].data.MSID;
            PageMethods.getAvailableNewInspectionsForAnMSID_AllProducts(MSID, onSuccess_getAvailableNewInspectionsForAnMSID_AllProducts, onFail_getAvailableNewInspectionsForAnMSID_AllProducts);
        }

        function onFail_getProductsByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in inspection.aspx, onFail_getProductsByMSID");
        }





        <%-------------------------------------------------------
        QueryString Handler
         -------------------------------------------------------%>
        function setH2() {
            GLOBAL_PO = '<%=this.Request.QueryString["PO"]%>';
            GLOBAL_INSPECTIONTYPE = '<%=this.Request.QueryString["InspectionType"]%>';
            document.querySelector("h2").innerHTML = GLOBAL_INSPECTIONTYPE + " inspection for " + GLOBAL_PO;
        }

         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
        $(function () {
            /*log window stuff: 
            1. place log under menu and add draggable functionality 
            2. add functionailty which update text based on current text */
            $("#btnViewTruck").hide();
            var isMobile = isOnMobile();
            if (isMobile == true) {
                $('.logWindow').hide();
                //$('#lblRejectTime').before('<br>');
            }
            else {
                placeLogWindowAndMakeDraggable();
                var tLogDisplayPref = sessionStorage.getItem('tLogDisplayPref');
                if (tLogDisplayPref == 'hide') {;
                    $("#tLogMax").show();
                    $("#tLogMini").hide();
                    $("#logTableWrapper").slideToggle();

                }
            }

            $("#logButton").click(function () {
                // var currentStat = $("#logButton").html();
                var logDisplay = $('#logTableWrapper').css('display');
                // alert(logDisplay);
                if (logDisplay == "block") {
                    //$("#logButton").html(" + ");
                    $("#tLogMax").show();
                    $("#tLogMini").hide();
                    sessionStorage.setItem('tLogDisplayPref', 'hide');

                }
                else {
                    // $("#logButton").html(" - ");
                    $("#tLogMax").hide();
                    $("#tLogMini").show();
                    sessionStorage.setItem('tLogDisplayPref', 'show');
                }
                $("#logTableWrapper").slideToggle();
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
                        $("#locationOptionsWrapper").show();
                        $("#locationLabelWrapper").show();
                        PageMethods.getLocationOptions(MSID, onSuccess_getLocationOptions, onFail_getLocationOptions);
                    }
                    else if (ui.items.length == 0) {
                        $("#tableLog").empty();
                    }
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
                    }

                }
            });
            $("#locationOptionsWrapper").hide();


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
                        { headerText: "", key: "INSPID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "TESTID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "RESULT", dataType: "integer", width: "0px", hidden: true },
                        { headerText: "", key: "USERID", dataType: "integer", width: "0px", hidden: true },
                        {
                            headerText: "Needs Result", key: "NEEDINPUT", dataType: "integer", width: "60px", template: "{{if(${RESULT} === -999)}}" +
                                              "<div class ='needsTestInput'>NEEDS INPUT</div>{{else}}<div>DONE</div>{{/if}}"
                        },
                        { headerText: "Not Applicable", key: "NA", dataType: "bool", width: "100px", formatter: radioFormatter, },
                        {
                            headerText: "Pass", key: "PASS", dataType: "bool", width: "60px", formatter: radioFormatter
                        },
                        { headerText: "Fail", key: "FAIL", dataType: "bool", width: "60px", formatter: radioFormatter, },
                        { headerText: "Test", key: "TESTDESC", dataType: "string", width: "100px", },
                        { headerText: "Comment", key: "COMMENT", dataType: "string", width: "800px", },   //david
                        { headerText: "Time Edited", key: "TIMESTAMP", dataType: "date", width: "75px", format: "MM/dd/yyyy HH:mm:ss", }
                    ],
                features: [
                    //{
                    //    name: 'Paging'
                    //},
                      {
                          name: 'Updating',
                          columnSettings:
                              [
                                  
                              { columnKey: "TESTID", readOnly: true },
                                    { columnKey: "NEEDINPUT", readOnly: true },
                                    { columnKey: "TESTDESC", readOnly: true },
                                    {
                                        columnKey: "TIMESTAMP",
                                        editorType: "text"
                                    },
                                    {
                                        columnKey: "NA",
                                        editorProvider: new $.ig.EditorProviderRadio(),
                                        editorOptions: { radioGroup: "group1" }
                                    },
                                    {
                                        columnKey: "PASS",
                                        editorProvider: new $.ig.EditorProviderRadio(),
                                        editorOptions: { radioGroup: "group1" }
                                    },
                                    {
                                        columnKey: "FAIL",
                                        editorProvider: new $.ig.EditorProviderRadio(),
                                        editorOptions: { radioGroup: "group1" }
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
                          editCellStarting: function (evt, ui) {
                              if ("TIMESTAMP" === ui.columnKey) {
                                  ui.keepEditing = false;
                                  return false;
                              }

                          },
                          editRowStarting: function (evt, ui) {
                              //var isPASSFAILBtnClicked = $("#grid").data("data-PASSFAILClick");
                              //if (isPASSFAILBtnClicked) { <%-- end editing if pass fail radio butttons clicked--%>
                              //$("#grid").data("data-PASSFAILClick", false); <%--reset--%>
                              ////return false;
                              //}
                              var check = ui;


                          },
                          editRowEnded: function (evt, ui) {
                              //if (ui.update && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                              var origEvent = evt.originalEvent;
                              if (typeof origEvent === "undefined") {
                                  ui.keepEditing = true;
                                  return false;
                              }


                              if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                  var rowNew = ui.values;
                                  var row = ui.owner.grid.findRecordByKey(ui.rowID);

                                  var newResult;
                                  if (rowNew.NA) {
                                      newResult = -1;
                                  }
                                  else if (rowNew.FAIL) {
                                      newResult = 0;
                                  }
                                  else if(rowNew.PASS) {
                                      newResult = 1;
                                  }
                                      // var inspectionID = row.INSPID;
                                  if (!checkNullOrUndefined(newResult) && (rowNew.NA != ui.oldValues.NA || rowNew.FAIL != ui.oldValues.FAIL || rowNew.PASS != ui.oldValues.PASS)) {
                                    //  PageMethods.setInspectionResult(row.INSPID, row.TESTID, newResult, rowNew.COMMENT, onSuccess_setInspectionResult, onFail_setInspectionResult, row.INSPID);//rowNew.TESTID);
                                      PageMethods.setInspectionResult(row.INSPID, row.TESTID, newResult, rowNew.COMMENT, onSuccess_setInspectionResult, onFail_setInspectionResult, ui.rowID);//rowNew.TESTID);
                                  }
                                  else if (ui.oldValues.COMMENT != rowNew.COMMENT) {
                                    //  PageMethods.setInspectionResult(row.INSPID, row.TESTID, null, rowNew.COMMENT, onSuccess_setInspectionResult, onFail_setInspectionResult, row.INSPID);//rowNew.TESTID);
                                      PageMethods.setInspectionResult(row.INSPID, row.TESTID, newResult, rowNew.COMMENT, onSuccess_setInspectionResult, onFail_setInspectionResult, ui.rowID);//rowNew.TESTID);
                                  }
                                  
                              }
                              else {
                                 // ui.keepEditing = true;
                                  return false;
                              }
                             
                              $("#grid").data("data-PASSFAILClick", false); <%--reset--%>
                          },
                      }
                ]
            }); <%--end of $("#grid").igGrid({--%>


            $("#gridMissingResults").igGrid({
                dataSource: [],
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
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
                        { headerText: "ETA", key: "ETA", dataType: "date", width: "75px", format: "MM/dd/yyyy HH:mm",  },
                        { headerText: "Location", key: "LOCLONG", dataType: "text", width: "125px" },
                        { headerText: "Inspection Name", key: "INSP", dataType: "text", width: "100px", },
                        {
                            headerText: "Inspection Finished", key: "INSPCLOSED", dataType: "text", width: "125px", formatter: boolYesNoFormatter,
                            <%-- //
                            template: "{{if((${INSPCLOSED}).toUpperCase() === 'NO')}}" +
                            "<div class ='needsTruckMove'>${INSPCLOSED}</div>{{else}}<div>${INSPCLOSED}</div>{{/if}}"
                            --%>
                        },
                    ],

            }); <%--end of $("#gridMissing")--%>


            $("#cboxCurrentInspectionsList").igCombo({
                dataSource: null,
                textKey: "INSPNAME",
                valueKey: "INSPID",
                width: "75%",
                autoComplete: true,
                enableClearButton: false,
                selectionChanging: function (evt, ui) {
                    //$("#trCreate").hide();
                    $("#dvResults").hide();
                    //$("#dvDeleteInspections").hide();
                    //$("#trInspectionActions").hide();
                    //$("#trComment").hide();
                },
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        var MSID = $("#cboxTruckList").igCombo("selectedItems")[0].data.MSID;
                        if (-1 === ui.items[0].data.INSPID) {
                            $("#trInspectionActions").hide();
                            $("#trComment").hide();
                            //$("#trCreate").show();
                            $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", null);
                            PageMethods.getProductsByMSID(MSID, onSuccess_getProductsByMSID, onFail_getProductsByMSID);
                            //var load;
                            //for (i = 0; i < GLOBAL_TRUCK_DATA.length; i++) {
                            //    if (GLOBAL_TRUCK_DATA[i].MSID === MSID) {
                            //        load = GLOBAL_TRUCK_DATA[i].LOADSHORT;
                            //    }
                            //}
                            //PageMethods.getAvailableNewInspectionsForAnMSID(MSID, load, onSuccess_getAvailableNewInspectionsForAnMSID, onFail_getAvailableNewInspectionsForAnMSID);
                        }
                        else {
                            //$("#dvDeleteInspections").show();
                        $("#trProductInspectionFilter").hide();
                        $("#trCreate").hide();
                        $("#trInspectionActions").show();
                        $("#trComment").show();
                        var inspectionID = ui.items[0].data.INSPID;

                            PageMethods.getInspectionGridData(inspectionID, onSuccess_getInspectionGridData, onFail_getInspectionGridData, inspectionID);
                        }
                    }
                }
            });



            $("#cboxProductInspectionFilter").igCombo({
                dataSource: null,
                textKey: "PRODNAME",
                valueKey: "PRODID",
                width: "75%",
                autoComplete: true,
                enableClearButton: false,
                selectionChanging: function (evt, ui) {
                },
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        var prodID = ui.items[0].data.PRODID;
                        var MSID = $("#cboxTruckList").igCombo("selectedItems")[0].data.MSID;

                        if (prodID == -1) {
                            PageMethods.getAvailableNewInspectionsForAnMSID_AllProducts(MSID, onSuccess_getAvailableNewInspectionsForAnMSID_AllProducts, onFail_getAvailableNewInspectionsForAnMSID_AllProducts);
                        }
                        else {
                            PageMethods.getAvailableNewInspectionsForAnMSID_OneProducts(prodID, MSID, onSuccess_getAvailableNewInspectionsForAnMSID_OneProducts, onFail_getAvailableNewInspectionsForAnMSID_OneProducts);
                        }

                    }
                }
            });
            $("#cboxLocationStatus").igCombo({
                dataSource: [{ "LOCSTATTEXT": null, "LOCSTAT": null }],
                textKey: "LOCSTATTEXT",
                valueKey: "LOCSTAT",
                width: "200px",
                autoComplete: true,
                mode: "dropdown",
                //disabled: true,
            });

            $("#cboxAvailableInspectionsList").igCombo({
                dataSource: null,
                textKey: "INSPNAME",
                valueKey: "INSPID",
                width: "75%",
                autoComplete: true,
                enableClearButton: false,
            });

            $("#cboxTruckList").igCombo({
                dataSource: null,
                textKey: "PO",
                valueKey: "MSID",
                width: "200px",
                autoComplete: true,
                enableClearButton: false,
                selectionChanging: function (evt, ui) {
                    $("#msgReadOnlyOnRejected").hide();
                    $("#trProductInspectionFilter").hide();
                    $("#trCreate").hide();
                    $("#trInspectionActions").hide();
                    $("#trComment").hide();

                    $("#dvTrailerInspections").hide();
                    $("#dvResults").hide();
                    //$("#dvDeleteInspections").hide();

                    $("#lblviewAddToPO").text("");
                    $("#cboxCurrentInspectionsList").data("data-currentInspectionStatus", null);
                    $("#cboxCurrentInspectionsList").igCombo("value", null);


                },
                selectionChanged: function (evt, ui) {
                    if (ui.items.length == 1) {
                        
                        //get data for grid summary for po selected
                        if (ui.items.length > 0) {
                            var pad = "00";
                            for (i = 0; i < GLOBAL_TRUCK_DATA.length; i++) {
                                if (GLOBAL_TRUCK_DATA[i].MSID === ui.items[0].data.MSID) {
                                    $("#btnViewTruck").show();
                                    var rDrop;
                                    if (GLOBAL_TRUCK_DATA[i].DROP) { rDrop = "YES"; } else { rDrop = "NO"; }

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

                                    $("#lblPO").text($.trim(String(GLOBAL_TRUCK_DATA[i].PO)));
                                    $("#lblETA").text($.trim(dformat));
                                    $("#lblStatus").text($.trim(GLOBAL_TRUCK_DATA[i].LOCLONG));

                                    var stat = GLOBAL_TRUCK_DATA[i].STATUSID;
                                    var loc = GLOBAL_TRUCK_DATA[i].LOCSHORT;

                                    //removed status 8 and 9 from list
                                    if (stat != '11' && stat != '12' && stat != '13' && stat != '14' && loc != 'GS' && loc != 'NOS' && loc != 'LAB') { 
                                        $("#cboxTruckList").data("data-isAbleToInspect", true);
                                    }
                                    else {
                                        $("#cboxTruckList").data("data-isAbleToInspect", false);
                                    }
                                  

                                    $("#lblCustomer").text($.trim(GLOBAL_TRUCK_DATA[i].CUSTNAME));
                                    $("#lblTruckType").text($.trim(GLOBAL_TRUCK_DATA[i].TRUCKTYPE));
                                    $("#lblLoad").text($.trim(GLOBAL_TRUCK_DATA[i].LOAD));
                                    $("#lblTrailNum").text($.trim(GLOBAL_TRUCK_DATA[i].TRAILNUM));
                                    $("#lblCabNum").text($.trim(GLOBAL_TRUCK_DATA[i].CABIN));
                                    $("#lblDrop").text($.trim(rDrop));
                                    $("#lblCarrier").text($.trim(GLOBAL_TRUCK_DATA[i].CARRIER));
                                    $("#lblShip").text($.trim(GLOBAL_TRUCK_DATA[i].SHIP));

                                    // $("#cboxLocationStatus").igCombo("value", GLOBAL_TRUCK_DATA[i].LOCSHORT);
                                    //$("#lblLocStat").text(GLOBAL_TRUCK_DATA[i].LOCLONG);
                                    //if(GLOBAL_TRUCK_DATA[i]

                                    //if (shouldEnableLocStatDropDown(GLOBAL_TRUCK_DATA[i].LOCSHORT)) {
                                    //    $("#dvLocStat").show();
                                    //    $("#dvLocStatDisabled").hide();
                                    //}
                                    //else {
                                    //    $("#dvLocStat").hide();
                                    //    $("#dvLocStatDisabled").show();
                                    //}

                                    if (GLOBAL_TRUCK_DATA[i].REJECT) {
                                        $("#lblisRejected").text("YES");
                                    }
                                    else {
                                        $("#lblisRejected").text("NO");
                                    }
                                   
                                    if (!checkNullOrUndefined(GLOBAL_TRUCK_DATA[i].TIMEREJECTED)) {
                                        var rDate = new Date(GLOBAL_TRUCK_DATA[i].TIMEREJECTED);
                                        $("#lblTimeRejected").text((1 + rDate.getMonth()).toString() + "/" + rDate.getDate().toString() + "/" + rDate.getFullYear().toString() + " " + ("00" + rDate.getHours()).slice(-2) + ":" + ("00" + rDate.getMinutes()).slice(-2));

                                    }
                                    else {
                                        $("#lblTimeRejected").text(' ');
                                    }
                                    

                                    $("#lblRejectTruck").text($.trim(GLOBAL_TRUCK_DATA[i].REJECTREASON));

                                    if (GLOBAL_TRUCK_DATA[i].LOCSHORT === 'INSPECT') {
                                       // $("#grid").data("data-isCurrentlyInInspection", true);
                                        //$("#btnViewTruck").show();
                                    }
                                    else {
                                        //$("#grid").data("data-isCurrentlyInInspection", false);
                                        //$("#btnViewTruck").hide();
                                    }

                                }
                            }

                        }

                        PageMethods.getLogDataByMSID(ui.items[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, ui.items[0].data.MSID);

                        //repopulate incomplete grid list
                        PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
                        PageMethods.getCurrentLocationAndStatus(ui.items[0].data.MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus, ui.items[0].data.MSID);
                        //$("#dvLocStat").show();
                        $("#dvTruckDetails").show();
                        //hide

                    }
                    else if (ui.items.length === 0) {
                        $("#btnViewTruck").hide();
                    }

                }
            });



            <%--Document ready calls--%>
            
           

            
           <%-- add grid cell click handler --%>
            $(document).delegate("#grid", "iggridcellclick", function (evt, ui) {

                if (ui.colKey === 'PASS' || ui.colKey === 'FAIL' || ui.colKey === 'NA') {
                    $("#grid").data("data-PASSFAILClick", true);

                }
                //else if (ui.colKey === 'FAIL') {
                //    $("#grid").data("data-PASSFAILClick", true);
                //} else if (ui.colKey === 'NA') {
                //    $("#grid").data("data-PASSFAILClick", true);
                //}
                else {
                    $("#grid").data("data-PASSFAILClick", false);
                }


            });

           

            hideAtInit(); <%-- hide html components --%>
            PageMethods.getListofTrucksCurrentlyInZXP(onSuccess_getListofTrucksCurrentlyInZXP, onFail_getListofTrucksCurrentlyInZXP);
            PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
            // setH2();
        }); <%--end of $(function () {--%>

    </script>

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="logWindow" >
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


    <h3>Display or create an inspection for a truck.</h3>
    <br />
    <br />


    <div id="dvSectionTruckDetails" style="width: 100%; ">
        <div><h2 style="display:inline">Select and View Truck Details</h2><h3  style="display:inline"> - Select a PO - Trailer to view the truck details </h3></div>
        <br />
        <div>Select PO - Trailer Num</div>
        <div><input id="cboxTruckList" /></div>
        <br />
        <div id="dvTruckDetails">
            <table class="tblTruckDetailsStyle">
                <tr>
                    <th>PO</th>
                    <th>Trailer#</th>
                    <th>ETA</th>
                    <th>Current Status</th>
                    <th>Customer</th>
                    <th>Truck Type</th>
                    <th>Load</th>
                    <th>Cab#</th>
                    <th>Drop Trailer</th>
                    <th>Carrier</th>
                    <th>Shipper</th>
                </tr>
                <tr>
                    <td style="width: 9%"><label id="lblPO"></label></td>
                    <td style="width: 9%"> <label id="lblTrailNum"></label></td>
                    <td style="width: 12%"> <label id="lblETA"></label></td>
                    <td style="width: 12%"><label id="lblStatus"></label> </td>
                    <td style="width: 9%"><label id="lblCustomer"></label></td>
                    <td style="width: 8%"><label id="lblTruckType"></label></td>
                    <td style="width: 8%"><label id="lblLoad"></label></td>
                    <td style="width: 8%"><label id="lblCabNum"></label></td>
                    <td style="width: 7%"><label id="lblDrop"></label></td>
                    <td style="width: 8%"><label id="lblCarrier"></label></td>
                    <td style="width: 10%"><label id="lblShip"></label></td>
                </tr>
                <tr><td colspan="11" style="background-color:gray"></td></tr>
                <tr><td>Rejected </td>
                    <td> <label id="lblisRejected"></label></td>
                    <td>Time Rejected:</td>
                    <td><label id="lblTimeRejected"></label> </td>
                    <td>Reject Reason:</td>
                    <td colspan="6">
                        <label id="lblRejectTruck"></label>
                      <%--  <textarea id="txtRejectTruck" style="width: 100%; height: 100%" placeholder="Reject Truck Reason:" maxlength="250" required="required"></textarea>--%>
                    </td>
                    
                </tr>
            </table>
        </div>
    </div>
    
    <br /><br /><br />
    <div id="dvSectionUpdateTruck" style="width: 100%; ">
        <div><h2  style="display:inline">Update Truck Location</h2><h3  style="display:inline"> - Update the location to where the truck/trailer is currently being inspected</h3></div>
        <div id="dvLocStat">
            <span><input id="cboxLocationStatus" /></span>
            <span ><input id="btnUpdateLocation" type="button" onclick="onclick_UpdateLocation()" value="Update" /></span>
        </div>
        <div id="dvLocStatDisabled"><label id="lblLocStat" style="color:blue"></label></div>
    </div>
    <br /><br /><br />
    <div id="dvSectionViewInspection" style="width: 100%; "> 
        <div>
            <div><h2 style="display:inline">View or Add New Inspection</h2><h3  style="display:inline"> - Select an inspection to view/edit or create a new inspection</h3></div>
            <div><h3 id="msgReadOnlyOnRejected" style="color: red;display:none;" >Read only, editing is disabled.</h3></div>
            <div><input id="btnViewTruck" type="button" onclick="onclick_ViewTruck()" value="View Inspections" /></div>
            <div><h2><label id="lblviewAddToPO"></label></h2></div>
        </div>
        <div id="dvTrailerInspections" style="width: 100%;  ">
            <div style="width: 100%">
                <table id="tblNewInspections" style="width: 100%">
                    <tr>
                        <td id="locationLabelWrapper"><label id="lblLocation"></label></td>
                        <td id="locationOptionsWrapper">
                            <h2>Update Location</h2>
                            <input id="cboxLocations" />
                            <button type="button" id="btn_updateLocation" onclick='onclick_btnUpdateLocation();'>Update Location</button>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">Select Inspection Or Create New</td>
                        <td style="width: 70%">
                            <div style="float: left; width: 100%"><input style="max-width:100%" id="cboxCurrentInspectionsList" /></div>
                        </td>
                    </tr>
                    <tr id="trProductInspectionFilter">
                        <td style="width: 30%">Filter Available Inspections Based On Products</td>
                        <td style="width: 70%">
                            <div id="dvProductInspectionFilter"> 
                                <input id="cboxProductInspectionFilter" style="max-width: 100%; float: left" />
                                <%--<input id="btnFilterInspection" style="float: right" type="button" value="Apply Filter" onclick="onclick_ApplyFilterInspection()" />--%>
                            </div>
                        </td>
                    </tr>
                    <tr id="trCreate">
                        <td style="width: 30%">Select Type Of Inspection To Create</td>
                        <td style="width: 70%">
                            <div id="dvAvailableInspections"> 
                                <input id="cboxAvailableInspectionsList" style="max-width: 100%; float: left" />
                                <input id="btnCreateInspection" style="float: right" type="button" value="Create New Inspection" onclick="onclick_CreateNewInspection()" />
                            </div>
                        </td>
                    </tr>
                    <tr id="trInspectionActions">
                        <td>
                            <div id="dvInspectionActionsStart"><input id="btnStartInspection" type="button" value="Start Inspection" onclick="onclick_StartInspection()" /></div>
                            <div id="dvInspectionActionsEnd"><input id="btnEndInspection" type="button" value="Finish Inspection" onclick=" onclick_EndInspection()" /></div>
                            <div id="dvInspectionActionsUpdate"><input id="btnUpdateInspection" type="button" value="Reopen Inspection" onclick="onclick_ReopenAndUpdateInspection()" /></div>
                            <div id="dvDeleteInspections"><input id="btnDeleteInspection" type="button" value="Delete Inspection" onclick="onclick_DeleteInspection()" /></div>
                        </td>
                        <td >
                            <div>Time Inspection Started: <label id="lblInspLastStartOpen"></label></div>
                            <div>Time Inspection Finished: <label id ="lblInspLastFin"></label></div>
                        </td>
                    </tr>
                    <tr id="trComment">
                        <td style="width: 30%">Inspection Comments:</td>
                        <td style="width: 70%">
                            <textarea id="txtInspectionComment" style=" max-width: 100%; width:75%; height: 100%" placeholder="Comments:" maxlength="250" required="required"></textarea>
                            <div id="lblCommentUpdated"style="float: right"></div>
                            <input id="btnUpdateInspectionComment" style="float: right" type="button" value="Update Comment" onclick="onclick_UpdateComment()" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="dvResults">
            <table id="grid"></table>
        </div>
    </div>
    

    <br /><br /><br />
    <div id="dvSectionMissingResults" style="width: 100%;  ">
        <div id="dvMissingResultsShow"><input type="button" onclick="showMissingResults(); return false;" value="Show Trucks with Incomplete Test" /></div>
        <div id="dvMissingResultsHide"><input type="button" onclick="hideMissingResults(); return false;" value="Hide Trucks with Incomplete Test" /></div>
        <div id="dvMissingResults"><table id="gridMissingResults"></table></div>
    </div>


</asp:Content>
