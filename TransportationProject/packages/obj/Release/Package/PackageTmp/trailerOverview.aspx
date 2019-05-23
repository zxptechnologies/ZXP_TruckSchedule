<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="trailerOverview.aspx.cs" Inherits="TransportationProject.trailerOverview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="Scripts/gridCreator.js"></script>
    <link href="Content/scheduleGrid.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Truck Schedule</h2>
    <h3>View, create, edit, and delete schedule for trucks. Shows all upcoming truck orders, all trucks that are within ZXP, and any trucks that have left ZXP but orders are still open in CMS.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ScriptMode="Release">
        <Scripts>
            <asp:ScriptReference Name="MicrosoftAjax.js" Path="Scripts/WebForms/MSAjax/MicrosoftAjax.js" />
        </Scripts>
    </asp:ScriptManager>

    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_LOAD_OPTIONS = [];
        var GLOBAL_STATUSTEXT_OPTIONS = [];
        var GLOBAL_LOCATION_OPTIONS = [];
        var GLOBAL_CUSTOMER_OPTIONS = [];
        var GLOBAL_PO_OPTIONS = [];
        var GLOBAL_SPOT_OPTIONS = [];
        var GLOBAL_TRUCK_OPTIONS = [];
        var GLOBAL_UNIT_OPTIONS = [];
        var GLOBAL_GRID_DATA = [];
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_SPOT_FORMAT_OPTIONS = [];
        var GLOBAL_STATUSTEXT_FORMAT_OPTIONS = [];
        var GLOBAL_LOCATION_FORMAT_OPTIONS = [];

        <%-------------------------------------------------------
        Functions
        ---------------------------------------------------------%>
        function concatAll() {
            var s = '';
            for (var x in arguments) {
                s += arguments[x] == null ? '' : arguments[x];
            }
            return s;
        }

        $(window).resize(function () {

            $("#dwFileUpload").dialog("option", "position", "center");
            $("#dwSchedule").dialog("option", "position", "center");

        });

         <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatCustomerCombo(val) {
            var i, cust;
            for (i = 0; i < GLOBAL_CUSTOMER_OPTIONS.length; i++) {
                cust = GLOBAL_CUSTOMER_OPTIONS[i];
                //if (cust.ID === val) {
                var newLabel = String(cust.ID).contains(val)
                if (newLabel) {
                    val = cust.LABEL;
                    String(cust.LABEL).contains(val)
                    return val;
                }
            }
            return "";
        }
        function formatStatusTextCombo(val) {
            var i, stat;
            for (i = 0; i < GLOBAL_STATUSTEXT_FORMAT_OPTIONS.length; i++) {
                stat = GLOBAL_STATUSTEXT_FORMAT_OPTIONS[i];
                if (stat.VALUE === val) {
                    val = stat.TEXT;
                    return val;
                }
            }
        }

        function formatLocationTextCombo(val) {
            var i, stat;
            for (i = 0; i < GLOBAL_LOCATION_FORMAT_OPTIONS.length; i++) {
                stat = GLOBAL_LOCATION_FORMAT_OPTIONS[i];
                if (stat.VALUE === val) {
                    val = stat.TEXT;
                    return val;
                }
            }
        }

        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatUnitCombo(val) {
            var i, unit;
            for (i = 0; i < GLOBAL_UNIT_OPTIONS.length; i++) {
                unit = GLOBAL_UNIT_OPTIONS[i];
                if (unit.ID === val) {
                    val = unit.LABEL;
                    return val;
                }
            }
        }

        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatLoadCombo(val) {
            var i, load;
            for (i = 0; i < GLOBAL_LOAD_OPTIONS.length; i++) {
                load = GLOBAL_LOAD_OPTIONS[i];
                if (load.LOAD === val) {
                    val = load.LABEL;
                    return val;
                }
            }
        }

            <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatSpotCombo(val) {
            var i, spot;
            for (i = 0; i < GLOBAL_SPOT_FORMAT_OPTIONS.length; i++) {
                spot = GLOBAL_SPOT_FORMAT_OPTIONS[i];
                if (spot.ID === val) {
                    val = spot.LABEL;
                    return val;
                }
            }
        }

            <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatTruckCombo(val) {

            var i, truck;
            for (i = 0; i < GLOBAL_TRUCK_OPTIONS.length; i++) {
                truck = GLOBAL_TRUCK_OPTIONS[i];
                if (truck.ID === val) {
                    val = truck.LABEL;
                }
            }
            return val;<%--return val even if not matched--%>
        }

        function openUploadDialog(ID) {
            var msid = $('#dwFileUpload').data("data-MSID", ID);
            $("#dwFileUpload span.anr_t:contains('Add new row')").text("Add new file"); <%-- change label on grid --%>
            $('#dwFileUpload td[title="Click to start adding new row"]').attr('title', "Click to start adding new file");
            PageMethods.getFileUploadsFromMSID(ID, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, ID);
        }

        function openPODetailDialog(MSID, PONUM, TrailerNum, Customer) {
            $("#dvPODetailsPONUM").text("");
            $("#spPODetailsMSID").text("");
            $("#spPODetailsTrailerNum").text("");
            $("#spPODetailsCustomer").text("");

            if (PONUM) {
                $("#dvPODetailsPONUM").text(PONUM);
            }
            if (MSID) {
                $("#spPODetailsMSID").text(MSID);
            }
            if (TrailerNum) {
                $("#spPODetailsTrailerNum").text(TrailerNum);
            }
            if (Customer) {
                $("#spPODetailsCustomer").text(formatCustomerCombo(Customer));
            }

            $("#dwPODetails").igDialog("open");
        }
        function openProductDetailDialog(MSID, PONUM) {
            $("#dvProductDetailsPONUM").text("");
            PageMethods.getPODetailsFromMSID(MSID, onSuccess_getPODetailsFromMSID, onFail_getPODetailsFromMSID, MSID);
            if (PONUM) {
                $("#dvProductDetailsPONUM").text(PONUM);

            }
        }

        function insertNewSchedule(jsonRow) {
            var check = 0;
            $.ajax({
                type: "POST",
                dataType: "json",
                contentType: "application/json",
                url: "trailerOverview.aspx/insertNewTruckScheduleData",
                data: jsonRow,
                success: function (dt) {
                    PageMethods.getTrailerGridData(onSuccess_getTrailerGridDataRebind, onFail_getTrailerGridData);
                },
                error: function () {
                    sendtoErrorPage("Error in trailerOverview.aspx insertNewSchedule() call.");
                }
            });
        }

        function hideVolumeValidationMsgs() {
            $("#msgWarningHeader").hide();
            $("#msgOverCMSMax").hide();
            $("#msgOverCMS90").hide();
            $("#msgOverCMS80").hide();
            $("#msgOverTankMax").hide();
            $("#msgOverTank90").hide();
            $("#msgOverTank80").hide();
            $("#msgMultipleTanks").hide();
            $("#msgMultipleProducts").hide();
            $("#msgNoTanks").hide();
            $("#msgMissingCMSorTankData").hide();
            $("#msgNegativeAmount").hide();
            $("#msgNoProductInformation").hide();
            $("#msgAffectedPO").hide();
            $("#msgWarningFooter").hide();
        }

        function showVolumeValidationMsgsBasedOnData(cmsData, tankData, cmsProjVol, tankProjVol, affectedOrders) {
                <%--Affected Future orders--%>
                if (affectedOrders.toString().trim()) { <%--check if over max allowed in CMS--%>
                    $("#msgWarningHeader").show();
                    $("#msgAffectedPO").show();
                    $("#msgWarningFooter").show();
                }
                <%--CMS Qty Check--%>
                if (cmsProjVol > cmsData[2]) { <%--check if over max allowed in CMS--%>
                    $("#msgWarningHeader").show();
                    $("#msgOverCMSMax").show();
                    $("#msgWarningFooter").show();
                }
                else if (cmsProjVol >= cmsData[2] * 0.9) { <%--check if over 90% of allowed in CMS--%>
                    $("#msgWarningHeader").show();
                    $("#msgOverCMS90").show();
                    $("#msgWarningFooter").show();

                }
                else if (cmsProjVol >= cmsData[2] * 0.8) { <%--check if over 80% of allowed in CMS--%>
                    $("#msgWarningHeader").show();
                    $("#msgOverCMS80").show();
                    $("#msgWarningFooter").show();

                };

                <%--Tank volume check--%>
                if (tankProjVol > tankData[1]) { <%--//check if over tank capacity--%>
                    $("#msgWarningHeader").show();
                    $("#msgOverTankMax").show();
                    $("#msgWarningFooter").show();

                }
                else if (tankProjVol > tankData[1] * 0.9) { <%--check if over 90% of tank capacity--%>
                    $("#msgWarningHeader").show();
                    $("#msgOverTank90").show();
                    $("#msgWarningFooter").show();

                }
                else if (tankProjVol > tankData[1] * 0.8) { <%--check if over 80% of tank capacity--%>
                    $("#msgWarningHeader").show();
                    $("#msgOverTank80").show();
                    $("#msgWarningFooter").show();

                };

                <%--Check for negative qtys--%>
                if (tankProjVol < 0 || cmsProjVol < 0) {
                    $("#msgNegativeAmount").show();
                }

                <%--Special tank formation--%>
                if (tankData[2] > 1) {
                    $("#msgWarningHeader").show();
                    $("#msgMultipleTanks").show();
                    $("#msgWarningFooter").show();
                }

                <%--No tank --%>
                if (tankData[2] < 1) {
                    $("#msgWarningHeader").show();
                    $("#msgNoTanks").show();
                    $("#msgWarningFooter").show();
                }

                <%--Multi-product tank--%>
                if (tankData[3] > 1) {
                    $("#msgWarningHeader").show();
                    $("#msgMultipleProducts").show();
                    $("#msgWarningFooter").show();
                }
                if (checkNullOrUndefined(cmsData[0]) || checkNullOrUndefined(cmsData[2]) || checkNullOrUndefined(tankData[0]) || checkNullOrUndefined(tankData[1]) ||
                    cmsData[0] === 0 || cmsData[2] === 0 || tankData[0] === 0 || tankData[1] === 0) {
                    $("#msgWarningHeader").show();
                    $("#msgMissingCMSorTankData").show();
                    $("#msgWarningFooter").show();
                }
            }

            function initGrid() {
                $("#grid").igGrid({
                    dataSource: GLOBAL_GRID_DATA,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    autofitLastColumn: true,
                    renderCheckboxes: true,
                    primaryKey: "MSID",
                    columns:
                    [
                    { headerText: "", key: "ETA", dataType: "date", width: "0px", hidden: true },
                    { headerText: "", key: "boolCMSOPEN", dataType: "boolean", width: "0px", hidden: true },
                    {
                        headerText: "Rejected", key: "REJECTED", dataType: "boolean", width: "80px", template: "{{if(${REJECTED})}}" +
                              "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                    },
                    { headerText: "Is open in CMS", dataType: "string", key: "isOpenInCMS", width: "50px" },
                    { headerText: "MSID", key: "MSID", dataType: "number", width: "0px", hidden: true },
                    { headerText: "PO", key: "PONUM", dataType: "string", width: "100px", template: "<div><input type='button' value='${PONUM}' onclick='openPODetailDialog(${MSID}, ${PONUM}, \"${TRAILER}\", \"${CUSTOMER}\"); return false;'></div>" },
                    { headerText: "Customer Order#", key: "ZXPPONUM", dataType: "string", width: "100px" },
                    {
                        headerText: "Product", key: "PRODID", dataType: "string", width: "150px", template: "{{if(${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                              "{{else}}Multiple{{/if}}"
                    },

                    { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
                    {
                        headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px", template: "{{if(${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                        "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialog(${MSID}, ${PONUM}); return false;'></div>{{/if}}"
                    },
                    { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "0px", hidden: true },
                    { headerText: "Drop Trailer", key: "DROP", dataType: "bool", width: "70px" },
                    { headerText: "Load", key: "LOAD", dataType: "string", width: "100px", formatter: formatLoadCombo },
                    { headerText: "Truck Type", key: "TRUCKTYPE", dataType: "string", width: "60px", formatter: formatTruckCombo },
                    { headerText: "SPOTID", key: "SPOTID", dataType: "number", width: "0%", hidden: true },
                    {
                        headerText: "Spot", key: "SPOT", unbound: true, dataType: "string", width: "60px",
                        formula: function (row, grid) {
                            return returnItemFromArray(GLOBAL_SPOT_FORMAT_OPTIONS, "ID", row.SPOTID, "LABEL");
                        }
                    },
                    { headerText: "Appt Date", key: "ETADATE", dataType: "date", format: "MM/dd/yyyy", width: "100px" },
                    { headerText: "Appt Time", key: "ETATIME", dataType: "string", width: "60px" },
                    { headerText: "Customer", key: "CUSTOMER", dataType: "string", width: "0px", hidden: true },
                    { headerText: "Location", key: "LOCSHORT", dataType: "string", width: "0px", hidden: true },
                    { headerText: "STATUSID", key: "STATID", dataType: "number", width: "0px", hidden: true },

                    { headerText: "Location", key: "LOCLONG", dataType: "string", width: "150px" },
                    { headerText: "Status", key: "STATIDTEXT", dataType: "string", width: "150px" },
                    { headerText: "File Upload", key: "FUPLOAD", dataType: "string", width: "100px", template: "<div><input type='button' value='View/Upload' onclick='openUploadDialog(${MSID}); return false;'></div>" },
                    { headerText: "Comments", key: "COMMENTS", dataType: "string", width: "200px" }
                    ],
                    features:
                    [
                        {
                            name: "Filtering",
                            dataFiltering: function (evt, ui) {
                                var newThng = [];
                                var nExpressions = [];
                                var check = ui.expressions;
                                for (i = 0; i < ui.newExpressions.length; i++) {
                                    var newcond = ui.newExpressions[i].cond;
                                    var newExpr = ui.newExpressions[i].expr;
                                    var newFieldName = ui.newExpressions[i].fieldName;

                                    if (!checkNullOrUndefined(newExpr)) {
                                        nExpressions.push(ui.newExpressions[i]);
                                    }
                                }
                                $("#grid").igGridFiltering("filter", nExpressions);
                                return false;
                            },

                        },

                        {
                            name: "Updating",
                            editMode: "row",
                            enableAddRow: true,
                            enableDeleteRow: true,
                            rowEditDialogContainment: "owner",
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            editCellStarting: function (evt, ui) {
                                //check if user can edit
                                var isPermitted = $("#body").data("canUserCRUDSched");
                                if (!isPermitted) {
                                    return false;
                                }
                                if ("CUSTOMER" === ui.columnKey || "FUPLOAD" === ui.columnKey) {
                                    return false;
                                }
                                if (!ui.rowAdding) {
                                    <%--Editing disabled for these rows when not adding--%>
                                    if ("PONUM" === ui.columnKey) {
                                        return false;
                                    }
                                    if ("ETADATE" === ui.columnKey) {
                                        var ETAeditor = $("#grid").igGridUpdating("editorForKey", "ETADATE");
                                        var newDate = new Date(ui.value);
                                        var ETADate = ETAeditor.igDatePicker("option", "value", newDate);
                                    }
                                }

                            },
                            editRowStarting: function (evt, ui) {
                                //check if user can edit
                                var isPermitted = $("#body").data("canUserCRUDSched");
                                if (!isPermitted) {
                                    return false;
                                }

                                var MSID = ui.rowID;
                                $("#grid").data("data-MSID", MSID);
                                $("#grid").data("data-PONUM", "");
                                $("#grid").data("newRowJSONData", "");
                                $("#gridFiles").data("data-POExist", 0);

                                hideVolumeValidationMsgs();

                                var isFormatting = false;
                                if (!ui.rowAdding) {
                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                    $("#dwFileUpload").data("data-MSID", row.MSID);
                                    PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);

                                    var isUploadBtnClicked = $("#grid").data("data-BUTTONClick");
                                    if (isUploadBtnClicked) {
                                        $("#grid").data("data-BUTTONClick", false);
                                        return false;
                                    }
                                    <%--if truck is inside plant (!NOS)) --%>
                                    if (row.LOCSHORT !== "NOS" || (row.LOCSHORT === "NOS" && (row.STATID === 10 || row.STATIDTEXT === 'Departed'))) {

                                        var isChecked = $("#chkCanEditSchedule")[0].checked;
                                        if (isChecked) {
                                            alert("If you would like to edit information for a truck that is already in the plant, please uncheck the Lock Schedule Editing checkbox above the schedule grid.");
                                            return false;
                                        }
                                    }

                                    var truckType = row.TRUCKTYPE;
                                    PageMethods.getSpotsByType(truckType, onSuccess_getSpotsByType, onFail_getSpotsByType, row.SPOTID)
                                     <%-- //Uncomment if zxp decides (that for bulk) to change to showing only spots associated to products instead of showing all available spots
                                    if (truckType.toString().toUpperCase().trim() === "VAN") {
                                        PageMethods.getSpotsByType(truckType, onSuccess_getSpotsByType, onFail_getSpotsByType, row.SPOTID)
                                    }
                                    else {

                                        
                                        PageMethods.getSpotsBasedOnProductsUnderPODetails(truckType, MSID, null, onSuccess_getSpotsBasedOnProductsUnderPODetails, onFail_getSpotsBasedOnProductsUnderPODetails, row.SPOTID);
                                    }
                                    --%>

                                    PageMethods.getLocationOptions(isFormatting, onSuccess_getLocationOptionsRebind, onFail_getLocationOptions, row.LOCSHORT);
                                    PageMethods.getStatusOptions(isFormatting, "NOS", onSuccess_getStatusOptionsRebind, onFail_getStatusOptions, row.STATID);
                                }
                                else {
                                    PageMethods.getAvailablePONumber(onSuccess_getAvailablePONumberRebind, onFail_getAvailablePONumber);
                                    PageMethods.getLocationOptions(isFormatting, onSuccess_getLocationOptionsRebind, onFail_getLocationOptions);
                                    PageMethods.getStatusOptions(isFormatting, "NOS", onSuccess_getStatusOptionsRebind, onFail_getStatusOptions);
                                }
                            },
                            rowAdding: function (evt, ui) {
                                //check if user can edit
                                var isPermitted = $("#body").data("canUserCRUDSched");
                                if (!isPermitted) {
                                    return false;
                                }

                                var origEvent = evt.originalEvent;
                                if (typeof origEvent === "undefined") {
                                    return false;
                                }
                                if (!(origEvent.type === "click" && ui.update === true)) {
                                    if (origEvent.type !== "click") {
                                        ui.keepEditing = true;
                                    }
                                }
                                else {

                                    var newRow = ui.values
                                    var splitHr = newRow.ETATIME.split(":");
                                    if (newRow.ETATIME) {
                                        var hr = splitHr[0];
                                        var min = splitHr[1];
                                        var ETA = new Date(newRow.ETADATE)
                                        ETA.setHours(hr);
                                        ETA.setMinutes(min);
                                        var customerID = $("#grid").data("customerID");
                                        var newRowDataArr = new Array(ETA, customerID, newRow.COMMENTS, newRow.PONUM, newRow.LOAD, newRow.DROP, newRow.SHIP, newRow.SPOT, newRow.TRUCKTYPE, newRow.TRAILER);
                                        var doesExists = $("#gridFiles").data("data-POExist");

                                        //reset
                                        $("#gridFiles").data("data-POExist", 0);
                                        $("#grid").removeData("customerID");

                                        var now = new Date();
                                        var reply = true;
                                        if (ETA < now) {
                                            reply = confirm("The date-time you have selected already passed. Continue?");
                                        }

                                        if (!reply) {
                                            ui.keepEditing = true;
                                            return false;
                                        }

                                        if (doesExists === 1) {
                                            reply = confirm("A schedule for PO: " + newRow.PONUM + " already exists. Continue adding new PO?");
                                        }
                                        if (reply || 0 === doesExists) {
                                            var jsonRowData = JSON.stringify({ rowData: newRowDataArr });
                                            var ctxParam = [];
                                            ctxParam[0] = newRow.PONUM;
                                            ctxParam[1] = jsonRowData;
                                            $("#grid").data("newRowJSONData", jsonRowData);
                                            PageMethods.getPOProductsDataForValidation(newRow.PONUM, ETA.toUTCString(), onSuccess_getPOProductsDataForValidation, onFail_getPOProductsDataForValidation, ctxParam);
                                            return false;
                                        }
                                        else {
                                            ui.keepEditing = true;
                                            return false;
                                        }
                                    }
                                    else {
                                        alert("Please enter a valid time.");
                                        return false;
                                    }

                                }
                            },
                            rowDeleting: function (evt, ui) {
                                //check if user can edit
                                var isPermitted = $("#body").data("canUserCRUDSched");
                                if (!isPermitted) {
                                    alert("Cannot delete the schedule based on your permissions.");
                                    return false;
                                    
                                }
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                var contextParam = [];
                                contextParam["MSID"] = row.MSID;
                                contextParam["PONUM"] = row.PONUM;
                                PageMethods.isUserAllowedToDeleteSchedule(row.MSID, onSuccess_isUserAllowedToDeleteSchedule, onFail_isUserAllowedToDeleteSchedule, contextParam)
                                return false;
                            },
                            editRowEnding: function (evt, ui) {
                                //check if user can edit
                                var isPermitted = $("#body").data("canUserCRUDSched");
                                if (!isPermitted) {
                                    return false;
                                }
                                var origEvent = evt.originalEvent;
                                if (typeof origEvent === "undefined") {
                                    ui.keepEditing = true;
                                    return false;
                                }

                                if (!(origEvent.type === "click" && ui.update === true && origEvent.currentTarget.innerText.toUpperCase() === 'DONE')) {

                                    if ((origEvent.type == "mousedown" || origEvent.type !== "click") && !origEvent.currentTarget.innerText.toUpperCase() === 'CANCEL') {
                                        ui.keepEditing = true;
                                    }
                                    return false;
                                }
                                else {
                                    if (!ui.rowAdding) {
                                        var newRow = ui.values;
                                        var MSID = $("#grid").data("data-MSID");

                                        if (newRow.ETATIME) {

                                            var splitHr = newRow.ETATIME.split(":");
                                            var hr = splitHr[0];
                                            var min = splitHr[1];
                                            var ETA = new Date(newRow.ETADATE)
                                            ETA.setHours(hr);
                                            ETA.setMinutes(min);


                                            var now = new Date();
                                            var reply = true;
                                            if (ETA < now) {
                                                reply = confirm("The date-time you have selected already passed. Continue?");
                                            }

                                            if (!reply) {
                                                ui.keepEditing = true;
                                                return false;
                                            }
                                            var newRowDataArr = new Array(MSID, ETA, newRow.COMMENTS, newRow.LOAD, newRow.DROP, newRow.SHIP, newRow.SPOT, newRow.TRUCKTYPE);
                                            var jsonText = JSON.stringify({ rowData: newRowDataArr })
                                            $.ajax({
                                                type: "POST",
                                                dataType: "json",
                                                contentType: "application/json",
                                                url: "trailerOverview.aspx/updateTruckSheduleData",
                                                data: jsonText,
                                                success: function (dt) {
                                                    PageMethods.getTrailerGridData(onSuccess_getTrailerGridDataRebind, onFail_getTrailerGridData);

                                                },
                                                error: function () {
                                                    sendtoErrorPage("Error in trailerOverview.aspx onFail_getTrailerGridData");
                                                }
                                            });
                                        }
                                        else {
                                            alert("Please select a valid time");
                                            ui.keepEditing = true;
                                            return false;
                                        }
                                        $("#gridFiles").data("data-POExist", 0);
                                    }
                                    else {
                                        <%--row adding--%>
                                        var newRow = ui.values;
                                        if (!newRow.ETATIME) {
                                            alert("Please select a valid time");
                                            ui.keepEditing = true;
                                        }
                                    }
                                }
                            },
                            columnSettings: [
                        {
                            columnKey: "boolCMSOPEN",
                            readOnly: true
                        },
                        {
                            columnKey: "isOpenInCMS",
                            readOnly: true
                        },
                        {
                            columnKey: "MSID",
                            readOnly: true
                        },
                        {
                            columnKey: "PRODCOUNT",
                            readOnly: true
                        },
                        {
                            columnKey: "PRODID",
                            readOnly: true
                        },
                        {
                            columnKey: "PRODDETAIL",
                            readOnly: true
                        },
                        {
                            columnKey: "ZXPPONUM",
                            readOnly: true
                        },
                        { columnKey: "WARNING", readOnly: true },
                        {
                            columnKey: "PONUM",
                            editorType: "combo",
                            required: true,
                            editorOptions: {
                                dropDownWidth: "500px",
                                mode: "editable",
                                filtertingType: "local",
                                highlightMatchesMode: "contains",
                                filteringCondition: "contains",
                                dataSource: GLOBAL_PO_OPTIONS,
                                itemTemplate: "<span title=\"${TEXT}\">${TEXT}</span>",
                                id: "cboxPO_trailerOverview",
                                textKey: "TEXT",
                                valueKey: "ID",
                                autoSelectFirstMatch: false,
                                virtualization: true,
                                dropDownOpening: function (evt, ui) {

                                },
                                selectionChanging: function (evt, ui) {
                                    $("#dwCMSProdDetails").igDialog("close");

                                    var check = ui;
                                },
                                selectionChanged: function (evt, ui) {

                                    if (ui.items.length > 0) {
                                        var PONum = ui.items[0].data.ID

                                        var editor = $("#grid").igGridUpdating("editorForKey", "ETADATE");
                                        $(editor).igEditor("value", "");
                                        editor = $("#grid").igGridUpdating("editorForKey", "ETATIME");
                                        $(editor).igEditor("value", "");

                                        $("#gridFiles").data("data-POExist", 0);
                                        var editor = $("#grid").igGridUpdating("editorForKey", "CUSTOMER");


                                        $(editor).igEditor("value", "");
                                        var isOrderNum = returnItemFromArray(GLOBAL_PO_OPTIONS, 'ID', PONum, 'ISORDER');
                                        if (isOrderNum === 1) {
                                            $("#cboxLoad").igCombo("value", "LOADOUT");
                                        }
                                        else {
                                            $("#cboxLoad").igCombo("value", "LOADIN");
                                        }

                                        $("#grid").data("data-PONUM", ui.items[0].data.ID);
                                        PageMethods.getPOData(parseInt(PONum), onSuccess_getPOData, onFail_getPOData);
                                        PageMethods.checkIfBulkAndGetProductFromPO(PONum, onSuccess_checkIfBulkAndGetProductFromPO, onFail_checkIfBulkAndGetProductFromPO);

                                        PageMethods.checkIfPOExistsInMainSchedule(parseInt(PONum), onSuccess_checkIfPOExistsInMainSchedule, onFail_checkIfPOExistsInMainSchedule)
                                    }
                                }
                            },
                        },
                        { columnKey: "DROP" },
                        {
                            columnKey: "LOAD",
                            editorType: "combo",
                            required: true,
                            editorOptions: {
                                mode: "editable",
                                enableClearButton: false,
                                dataSource: GLOBAL_LOAD_OPTIONS,
                                id: "cboxLoad",
                                textKey: "LABEL",
                                valueKey: "LOAD",
                                autoSelectFirstMatch: true,
                            },
                        },
                        {
                            columnKey: "ETADATE",
                            editorType: "datepicker",
                            //required: true,
                            editorOptions: {
                                mode: "editable",
                                dateInputFormat: "MM/dd/yyyy",
                                id: "dpETADATE",
                                textChanged: function (evt, ui) {
                                    var editor = $("#grid").igGridUpdating("editorForKey", "ETATIME");
                                    $(editor).igEditor("value", "");
                                }
                            }
                        },
                        {
                            columnKey: "ETATIME",
                            editorType: "text",
                            editorOptions: {
                                id: "txtETATIME",
                                readOnly: true,
                                mousedown: function (evt, ui) {
                                    var ETAeditor = $("#grid").igGridUpdating("editorForKey", "ETADATE");
                                    var ETADate = ETAeditor.igEditor("value");
                                    var strDate = null;
                                    if (ETADate) {
                                        strDate = String(ETADate.getMonth() + 1) + "/" + String(ETADate.getDate()) + "/" + String(ETADate.getFullYear())
                                    }

                                    var trucktype = $("#cboxTruckType").igCombo("value");
                                    var spot = $("#cboxSpot").igCombo("value");

                                    if (!checkNullOrUndefined(trucktype) && !checkNullOrUndefined(spot) && strDate && ETADate) {

                                        var MSID = $("#grid").data("data-MSID"); <%--can be -1 if new row--%>
                                        var PONUM = $("#cboxPO_trailerOverview").igCombo("value");
                                        
                                        if (-1 === MSID && (!checkNullOrUndefined(PONUM) && typeof PONUM != 'object')) {
                                            PageMethods.getTimeslotsData(strDate, trucktype, spot, MSID, PONUM, onSuccess_getTimeslotsData, onFail_getTimeslotsData);
                                        }
                                        else {
                                            PageMethods.getTimeslotsData(strDate, trucktype, spot, MSID, null, onSuccess_getTimeslotsData, onFail_getTimeslotsData);
                                        }
                                    }
                                    else {
                                        alert("Please make sure you have selected a Truck Type, Spot and Appt Date");
                                    }
                                }
                            },
                        },

                        {
                            columnKey: "TRAILER",
                            editorType: "text",
                            editorOptions: {
                                maxLength: 15,
                            }
                        },

                        {
                            columnKey: "CUSTOMER",
                            editorType: "text",
                            editorOptions: {
                                mode: "readonly",
                                id: "txtCustomer_trailerOverview",
                            }
                        },
                        { columnKey: "SHIP", editorType: "text" },
                        {
                            columnKey: "LOCSHORT",
                            readOnly: true
                        },
                        {
                            columnKey: "STATID",
                            readOnly: true
                        },
                        {
                            columnKey: "LOCLONG",
                            readOnly: true
                        },
                        {
                            columnKey: "STATIDTEXT",
                            readOnly: true
                        },
                        {
                            columnKey: "SPOTID",
                            readOnly: true
                        },

                        {
                            columnKey: "SPOT",
                            editorType: "combo",
                            required: false,
                            editorOptions: {
                                mode: "editable",
                                enableClearButton: false,
                                dataSource: GLOBAL_SPOT_OPTIONS,
                                id: "cboxSpot",
                                textKey: "LABEL",
                                valueKey: "ID",
                                autoSelectFirstMatch: true,
                                dropDownOpening: function (evt, ui) {
                                    var truckType = $("#cboxTruckType").igCombo("value");
                                    if (!truckType) {
                                        alert("Select Truck Type first.");
                                        return false;
                                    }
                                },
                                selectionChanged: function (evt, ui) {
                                    var editor = $("#grid").igGridUpdating("editorForKey", "ETADATE");
                                    $(editor).igEditor("value", "");
                                    editor = $("#grid").igGridUpdating("editorForKey", "ETATIME");
                                    $(editor).igEditor("value", "");
                                }
                            }
                        },
                        {
                            columnKey: "TRUCKTYPE",
                            editorType: "combo",
                            required: true,
                            editorOptions: {
                                mode: "editable",
                                enableClearButton: false,
                                dataSource: GLOBAL_TRUCK_OPTIONS,
                                id: "cboxTruckType",
                                textKey: "LABEL",
                                valueKey: "ID",
                                autoSelectFirstMatch: false,
                                selectionChanged: function (evt, ui) {
                                    var MSID = $("#grid").data("data-MSID");
                                    var truckType = ui.items[0].data.ID;
                                    PageMethods.getSpotsByType(truckType, onSuccess_getSpotsByType, onFail_getSpotsByType)
                                    <%-- //Uncomment if zxp decides (that for bulk) to change to showing only spots associated to products instead of showing all available spots
                                    //if (truckType.toString().toUpperCase().trim() === "VAN") {
                                    //    PageMethods.getSpotsByType(truckType, onSuccess_getSpotsByType, onFail_getSpotsByType)
                                    //}
                                    //else {
                                    //    if (-1 === MSID) {
                                    //        var PONUM = $("#cboxPO_trailerOverview").igCombo("value");
                                    //        if (!checkNullOrUndefined(PONUM) && typeof PONUM != 'object' ) {
                                    //            PageMethods.getSpotsBasedOnProductsUnderPODetails(truckType, MSID, PONUM, onSuccess_getSpotsBasedOnProductsUnderPODetails, onFail_getSpotsBasedOnProductsUnderPODetails);
                                    //        }
                                    //    }
                                    //    else {
                                    //        PageMethods.getSpotsBasedOnProductsUnderPODetails(truckType, MSID, null, onSuccess_getSpotsBasedOnProductsUnderPODetails, onFail_getSpotsBasedOnProductsUnderPODetails);
                                    //    }
                                    //}
                                    --%>

                                    var editor = $("#grid").igGridUpdating("editorForKey", "ETADATE");
                                    $(editor).igEditor("value", "");
                                    editor = $("#grid").igGridUpdating("editorForKey", "ETATIME");
                                    $(editor).igEditor("value", "");
                                }
                            }
                        },
                        {
                            columnKey: "FUPLOAD",
                            readOnly: true
                        },
                        {
                            columnKey: "REJECTED",
                            readOnly: true
                        },
                        {
                            columnKey: "COMMENTS",
                            editorType: "text",
                        },
                            ]
                        },
                    ]

                });

                <%--end of .igGrid()--%>
                $("#grid").data("isFiltering", 0);

            } <%--end of function initGrid() --%>


        <%-------------------------------------------------------
        Pagemethods Handlers
        //-------------------------------------------------------%>
        function onSuccess_getPOProductsDataForValidation(value, ctx, methodName) {
            var PONum = ctx[0];
            var jsonRowData = ctx[1];
            $("#dwCMSProdDetails").data("PONUM", PONum);

            var gridData = [];
            if (checkNullOrUndefined(value)) {
                $("#msgWarningHeader").show();
                $("#msgNoProductInformation").show();
                $("#msgWarningFooter").show();
            }
            else {
                for (i = 0; i < value.length; i++) {
                    var cmsData = value[i][11]; <%--   CMS Data with SumQtyOnHand,MinQty, MaxQty, Unit --%>
                    var tankData = value[i][12]; <%-- SQL Tank Data  with ttlTankCapacity, ttlCurrentTankVolume, numberOfTanksWithProducts, maxProdCount--%>
                    var cmsProjVol = value[i][8];
                    var tankProjVol = value[i][10];
                    var affectedOrders = value[i][13];

                    showVolumeValidationMsgsBasedOnData(cmsData, tankData, cmsProjVol, tankProjVol, affectedOrders);

                    gridData[i] = {
                        "CMSPROD": value[i][0], "ISSALES": value[i][1], "UNIT": value[i][2],
                        "QTYPONUM": value[i][3], "QTYCMSORDERS": value[i][4],
                        "QTYLOADIN": value[i][5], "QTYLOADOUT": value[i][6],
                        "QTYCMSONHAND": value[i][7], "PROJVOLUMEUSINGCMS": cmsProjVol,
                        "QTYINTANK": value[i][9], "PROJVOLUMEUSINGTANK": tankProjVol,
                        "AFFECTEDPO": affectedOrders
                    };
                }
            }

            $("#gridCMSProdDetails").igGrid("option", "dataSource", gridData);
            $("#gridCMSProdDetails").igGrid("dataBind");
            $("#dwCMSProdDetails").igDialog("open");

        }

        function onFail_getPOProductsDataForValidation(value, ctx, methodName) {


            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getPOProductsDataForValidation");
        }


        function onSuccess_checkIfBulkAndGetProductFromPO(value, ctx, methodName) {
            var productCount = value[0];
            var isBulk = value[1];
            var spotID = value[2]
            var truckType = (isBulk ? "Bulk" : "Van");

            $("#cboxTruckType").igCombo("value", truckType); <%--set trucktype--%>
            PageMethods.getSpotsByType(truckType, onSuccess_getSpotsByType, onFail_getSpotsByType, spotID)
            <%-- //Uncomment if zxp decides (that for bulk) to change to showing only spots associated to products instead of showing all available spots
            //var MSID = $("#grid").data("data-MSID");
            //if (isBulk) {
            //    if (-1 === MSID) {
            //        var PONUM = $("#cboxPO_trailerOverview").igCombo("value");
            //        if (!checkNullOrUndefined(PONUM) && typeof PONUM != 'object') {
            //            if (1 === productCount) {
            //                PageMethods.getSpotsBasedOnProductsUnderPODetails(truckType, MSID, PONUM, onSuccess_getSpotsBasedOnProductsUnderPODetails, onFail_getSpotsBasedOnProductsUnderPODetails, spotID);
            //            }
            //            else {
            //                PageMethods.getSpotsBasedOnProductsUnderPODetails(truckType, MSID, PONUM, onSuccess_getSpotsBasedOnProductsUnderPODetails, onFail_getSpotsBasedOnProductsUnderPODetails);
            //            }
            //        }
            //    }
            //    else {
            //        PageMethods.getSpotsBasedOnProductsUnderPODetails(truckType, MSID, null, onSuccess_getSpotsBasedOnProductsUnderPODetails, onFail_getSpotsBasedOnProductsUnderPODetails);
            //    }
            //}
            //else {
            //    PageMethods.getSpotsByType(truckType, onSuccess_getSpotsByType, onFail_getSpotsByType)
            //}
        --%>

        }
        function onFail_checkIfBulkAndGetProductFromPO(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_checkIfBulkAndGetProductFromPO");
        }

        function onSuccess_updateFileUploadData(value, ctx, methodName) {
            <%--Success do nothing --%>$("#gridFiles").igGrid("commit");
        }

        function onFail_updateFileUploadData(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_updateFileUploadData");
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
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getPODetailsFromMSID");
        }

        function onSuccess_checkIfPOExistsInMainSchedule(value, ctx, methodName) {
            <%--check if rowCount > 0 ; if true alert that PONumber exists in database --%>
            if (value > 0) {
                alert("An existing schedule for that PO exists. Please make sure you are editing the correct schedule before adding.");
                $("#gridFiles").data("data-POExist", 1);
            }
            else {
                $("#gridFiles").data("data-POExist", 0);
            }
        }

        function onFail_checkIfPOExistsInMainSchedule(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_checkIfPOExistsInMainSchedule");
        }

        function onSuccess_getPOData(value, ctx, methodName) {
            var customerID = value[0][0];
            var customerName = value[0][1];
            var newData = [];
            newData[0] = { "LABEL": customerName, "ID": customerID };

            $("#grid").data("customerID", customerID);
            $("#txtCustomer_trailerOverview").igEditor("text", customerName);

            var cid = $("#grid").data("customerID");
            var cname = $("#txtCustomer_trailerOverview").igEditor("text");
        }

        function onFail_getPOData(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getPOData");
        }

        function onSuccess_getCOFAFileUploadsFromMSID(value, ctx, methodName) {
            var gridData = [];
            for (i = 0; i < value.length; i++) {
                gridData[i] = {
                    "FID": value[i][0], "MSID": value[i][1], "FILETYPEID": value[i][2], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5],
                    "FNAMEOLD": value[i][6], "CMSPRODUCTID": value[i][7], "CMSPRODUCTNAME": value[i][8]
                };
            }
            $("#gridCOFAFiles").igGrid("option", "dataSource", gridData);
            $("#gridCOFAFiles").igGrid("dataBind");
            $("#dwFileUpload").data("ID", ctx).igDialog("open");
        }

        function onFail_getCOFAFileUploadsFromMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getCOFAFileUploadsFromMSID");
        }

        function onSuccess_getFileUploadsFromMSID(value, ctx, methodName) {
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
                    if (1 === value[i][2]) { <%-- if filetype is BOL -> BOL ===1 (set to filetype in db if changed)--%>
                        $('#alinkBOL').text(value[i][6]);
                        $("#alinkBOL").attr("href", value[i][4] + "/" + value[i][5])
                        $('#dBOLcontainer').data("data-fileID", value[i][0]);
                        $('#dUpBOL').hide();
                        $('#dDelBOL').show();
                    }
                    else if (2 === value[i][2]) { <%-- if filetype is COFA -> COFA === 2 (set to filetype in db if changed)--%>
                        $('#alinkCOFA').text(value[i][6]);
                        $("#alinkCOFA").attr("href", value[i][4] + "/" + value[i][5])
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
            PageMethods.getCOFAFileUploadsFromMSID(msid, onSuccess_getCOFAFileUploadsFromMSID, onFail_getCOFAFileUploadsFromMSID, msid);
        }
        else { <%-- no data --%>
                var gridData = [];
                $("#gridFiles").igGrid("option", "dataSource", gridData);
                $("#gridFiles").igGrid("dataBind");

                PageMethods.getCOFAFileUploadsFromMSID(msid, onSuccess_getCOFAFileUploadsFromMSID, onFail_getCOFAFileUploadsFromMSID, msid);
            }
        }

        function onFail_getFileUploadsFromMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getFileUploadsFromMSID");
        }


        function onSuccess_getLoadOptions(value, ctx, methodName) {
            GLOBAL_LOAD_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_LOAD_OPTIONS[i] = { "LOAD": value[i][0], "LABEL": value[i][1] };
            }
            PageMethods.getUnits(onSuccess_getUnits, onFail_getUnits);
        }

        function onFail_getLoadOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getLoadOptions");
        }

        function onSuccess_getUnits(value, ctx, methodName) {
            GLOBAL_UNIT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_UNIT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            PageMethods.getCustomerOptions(onSuccess_getCustomerOptions, onFail_getCustomerOptions);
        }

        function onFail_getUnits(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getUnits");
        }
        function onSuccess_getCustomerOptions(value, ctx, methodName) {
            GLOBAL_CUSTOMER_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_CUSTOMER_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            PageMethods.getAvailablePONumber(onSuccess_getAvailablePONumber, onFail_getAvailablePONumber);
        }

        function onFail_getCustomerOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getCustomerOptions");
        }
        function onSuccess_getAvailablePONumberRebind(value, ctx, methodName) {
            GLOBAL_PO_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                var part1 = value[i][1], part2 = value[i][2], part3 = value[i][3];
                if (part1) {
                    part1 = part1.trim();
                }
                if (part2) {
                    part2 = "," + part2.trim();
                }
                if (part3) {
                    part3 = "," + part3.trim();
                }
                var poText = concatAll(value[i][0], " - Parts:", part1, part2, part3, "...");
                GLOBAL_PO_OPTIONS[i] = { "ID": value[i][0], "TEXT": poText, "ISORDER": value[i][4] };
            }
            $("#cboxPO_trailerOverview").igCombo("option", "dataSource", GLOBAL_PO_OPTIONS);
            $("#cboxPO_trailerOverview").igCombo("dataBind");
        }


        function onSuccess_getAvailablePONumber(value, ctx, methodName) {
            GLOBAL_PO_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                var part1 = value[i][1], part2 = value[i][2], part3 = value[i][3];
                if (part1) {
                    part1 = part1.trim();
                }
                if (part2) {
                    part2 = part2.trim();
                }
                if (part3) {
                    part3 = part3.trim();
                }
                var poText = concatAll(value[i][0], " - Parts:", part1, part2, part3);
                GLOBAL_PO_OPTIONS[i] = { "ID": value[i][0], "TEXT": poText, "ISORDER": value[i][4] };
            }
            var isFormatting = true;
            PageMethods.getLocationOptions(isFormatting, onSuccess_getLocationOptions, onFail_getLocationOptions);
        }

        function onFail_getAvailablePONumber(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getAvailablePONumber");
        }

        function onSuccess_getLocationOptions(value, ctx, methodName) {
            GLOBAL_LOCATION_OPTIONS.length = 0;
            GLOBAL_LOCATION_FORMAT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_LOCATION_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
                GLOBAL_LOCATION_FORMAT_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
            }
            var isFormatting = true;
            PageMethods.getStatusOptions(isFormatting, "", onSuccess_getStatusOptions, onFail_getStatusOptions);

        }

        function onSuccess_getLocationOptionsRebind(value, ctx_currentVal, methodName) {
            GLOBAL_LOCATION_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_LOCATION_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
            }
            $("#cboxLocation").igCombo("option", "dataSource", GLOBAL_LOCATION_OPTIONS);
            $("#cboxLocation").igCombo("dataBind");
            $("#cboxLocation").igCombo("value", ctx_currentVal)
        }

        function onFail_getLocationOptions(ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getLocatinOptions");
        }

        function onSuccess_getStatusOptions(value, ctx, methodName) {
            GLOBAL_STATUSTEXT_OPTIONS.length = 0;
            GLOBAL_STATUSTEXT_FORMAT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_STATUSTEXT_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
                GLOBAL_STATUSTEXT_FORMAT_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
            }
            PageMethods.getSpots(onSuccess_getSpots, onFail_getSpots);
        }
        function onSuccess_getStatusOptionsRebind(value, ctx_currentVal, methodName) {
            GLOBAL_STATUSTEXT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_STATUSTEXT_OPTIONS[i] = { "VALUE": value[i][0], "TEXT": value[i][1] };
            }
            $("#cboxStatusText").igCombo("option", "dataSource", GLOBAL_STATUSTEXT_OPTIONS);
            $("#cboxStatusText").igCombo("dataBind");
            $("#cboxStatusText").igCombo("value", ctx_currentVal)
        }

        function onFail_getStatusOptions(ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getStatusOptions");
        }
        function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }
        function onFail_getLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx onFail_getLogDataByMSID");
        }

        function onSuccess_isUserPermittedToEdit(value, ctx, methodName) {
            var isPermitted = value;
            $("#body").data("canUserCRUDSched", value);
        }
        
        function onFail_isUserPermittedToEdit(value, ctx, methodName) {

            sendtoErrorPage("Error in trailerOverview.aspx onFail_isUserPermittedToEdit");
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
            sendtoErrorPage("Error in trailerOverview.aspx onFail_getLogList");
        }
        function onSuccess_getSpots(value, ctx, methodName) {
            GLOBAL_SPOT_FORMAT_OPTIONS.length = 0;

            for (i = 0; i < value.length; i++) {
                GLOBAL_SPOT_FORMAT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            PageMethods.getTruckTypes(onSuccess_getTruckTypes, onFail_getTruckTypes);
        }

        function onFail_getSpots(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getSpots");
        }

        function onSuccess_getSpotsBasedOnProductsUnderPODetails(value, ctx, methodName) {
            GLOBAL_SPOT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_SPOT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            $("#cboxSpot").igCombo("option", "dataSource", GLOBAL_SPOT_OPTIONS);
            $("#cboxSpot").igCombo("dataBind");
            if (ctx) {
                $("#cboxSpot").igCombo("value", ctx);
            }
        }

        function onFail_getSpotsBasedOnProductsUnderPODetails(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getSpotsBasedOnProductsUnderPODetails");
        }
        function onSuccess_getSpotsByType(value, ctx, methodName) {
            GLOBAL_SPOT_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_SPOT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            $("#cboxSpot").igCombo("option", "dataSource", GLOBAL_SPOT_OPTIONS);
            $("#cboxSpot").igCombo("dataBind");
            if (ctx) {
                $("#cboxSpot").igCombo("value", ctx);
            }
        }
        function onFail_getSpotsByType(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getSpotsByType");
        }

        function onSuccess_getTruckTypes(value, ctx, methodName) {
            GLOBAL_TRUCK_OPTIONS.length = 0;
            for (i = 0; i < value.length; i++) {
                GLOBAL_TRUCK_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
            }
            PageMethods.getTrailerGridData(onSuccess_getTrailerGridData, onFail_getTrailerGridData);
        }

        function onFail_getTruckTypes(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getTruckTypes");
        }

        function onSuccess_getTrailerGridData(value, ctx, methodName) {
            for (i = 0; i < value.length; i++) {
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][18]);

                var strETATime = ("00" + value[i][1].getHours()).slice(-2) + ":" + ("00" + value[i][1].getMinutes()).slice(-2);
                var prodCount = value[i][19]
                var prodDetail = prodCount < 2 ? value[i][21] : "multiple";
                var prodID = prodCount < 2 ? value[i][20] : "multiple";

                GLOBAL_GRID_DATA[i] = {
                    "MSID": value[i][0], "ETA": value[i][1], "ETADATE": value[i][1], "ETATIME": strETATime, "COMMENTS": value[i][2],
                    "LOAD": value[i][3], "LOADTEXT": value[i][4], "PONUM": value[i][5],
                    "CUSTOMER": value[i][6], "DROP": value[i][7], "SHIPPER": value[i][8], "SPOT": value[i][9], "TRUCKTYPE": value[i][10],
                    "REJECTED": value[i][11], "TRAILER": value[i][12], "WARNING": "", "LOCSHORT": value[i][13], "LOCLONG": value[i][14],
                    "STATID": value[i][15], "STATIDTEXT": value[i][16], "SPOTDESC": value[i][17], "SPOTID": value[i][9],
                    "boolCMSOPEN": value[i][18], "isOpenInCMS": isOpenInCMS, "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail,
                    "ZXPPONUM": value[i][22]
                };
            }

            <%--After dropdown box data are  retrieved and set to global vars, initialize grid --%>
            initGrid();
        }
        function onSuccess_getTrailerGridDataRebind(value, ctx, methodName) {
            GLOBAL_GRID_DATA.length = 0;

            for (i = 0; i < value.length; i++) {
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][18]);
                var strETATime = ("00" + value[i][1].getHours()).slice(-2) + ":" + ("00" + value[i][1].getMinutes()).slice(-2);
                var prodCount = value[i][19]
                var prodDetail = prodCount < 2 ? value[i][21] : "multiple";
                var prodID = prodCount < 2 ? value[i][20] : "multiple";
                GLOBAL_GRID_DATA[i] = {

                    "MSID": value[i][0], "ETA": value[i][1], "ETADATE": value[i][1], "ETATIME": strETATime, "COMMENTS": value[i][2],
                    "LOAD": value[i][3], "LOADTEXT": value[i][4], "PONUM": value[i][5],
                    "CUSTOMER": value[i][6], "DROP": value[i][7], "SHIPPER": value[i][8], "SPOT": value[i][9], "TRUCKTYPE": value[i][10],
                    "REJECTED": value[i][11], "TRAILER": value[i][12], "WARNING": "", "LOCSHORT": value[i][13], "LOCLONG": value[i][14],
                    "STATID": value[i][15], "STATIDTEXT": value[i][16], "SPOTDESC": value[i][17], "SPOTID": value[i][9],
                    "boolCMSOPEN": value[i][18], "isOpenInCMS": isOpenInCMS, "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail,
                    "ZXPPONUM": value[i][22]
                };
            }
            <%--Rebind Data--%>
            $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA);
            $("#grid").igGrid("dataBind");
        }

        function onFail_getTrailerGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx onFail_getTrailerGridData");
        }


        function onSuccess_isUserAllowedToDeleteSchedule(value, ctx, methodName) {
            var MSID = ctx["MSID"];
            var PONUM = ctx["PONUM"];
            if (value) {
                var canDelete = value[0];
                var msg = value[1];
                if (!canDelete) {
                    alert(msg);
                }
                else {
                    var r = confirm("Continue deleting schedule for " + PONUM + "?");
                    if (r == true) {
                        var jsonText = JSON.stringify({ msid: MSID })
                        $.ajax({
                            type: "POST",
                            dataType: "json",
                            contentType: "application/json",
                            url: "trailerOverview.aspx/deleteTruckScheduleData",
                            data: jsonText,
                            success: function (dt) {
                                PageMethods.getTrailerGridData(onSuccess_getTrailerGridDataRebind, onFail_getTrailerGridData);
                            },
                            error: function () {
                                sendtoErrorPage("Error in trailerOverview.aspx onFail_getTrailerGridData");
                            }
                        });
                    }
                }
            }
        }

        function onFail_isUserAllowedToDeleteSchedule(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_isUserAllowedToDeleteSchedule");
        }


        function onSuccess_processFileAndData(value, ctx, methodName) {
            if (ctx) {
                if ("BOL" === ctx[1]) {
                    <%--Add entry into DB --%>
                    PageMethods.addFileDBEntry(ctx[2], "BOL", ctx[0], value[1], value[0], "BOL", onSuccess_addFileDBEntry, onFail_addFileDBEntry, ctx);
                }
                else if ("COFA" === ctx[1]) {
                    <%--Add entry into DB --%>
                    PageMethods.addFileDBEntry(ctx[2], "COFA", ctx[0], value[1], value[0], "COFA", onSuccess_addFileDBEntry, onFail_addFileDBEntry, ctx);
                }
                else if ("OTHER" === ctx[1]) {
                    <%--Add OTHER filetype entry into db only happens on add row finished because need to get Detail column--%>
                    <%--add attributes related to grid for use when adding new row --%>
                    $("#gridFiles").data("data-FPath", value[0]);
                    $("#gridFiles").data("data-FNameNew", value[1]);
                    $("#gridFiles").data("data-FNameOld", ctx[0]);

                    <%--change text of add new row's filename column to uploaded file's original name --%>
                    $("#dwFileUpload tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(ctx[0]);
                }
    }
}

function onFail_processFileAndData(value, ctx, methodName) {
    sendtoErrorPage("Error in trailerOverview.aspx, onFail_processFileAndData");
}

function onSuccess_deleteFileDBEntry(value, FileTypeAndID, methodName) {
    switch (FileTypeAndID[0]) {
        case "OTHER":
            $("#gridFiles").igGridUpdating("deleteRow", FileTypeAndID[1]);
            $("#gridFiles").igGrid("commit");
            break;
        case "BOL":
            $('#alinkBOL').text();
            $('#dUpBOL').show();
            $('#dDelBOL').hide();
            $("#gridFiles").igGridUpdating("deleteRow", FileTypeAndID[1]);
            $("#gridFiles").igGrid("commit");
            break;
    }
    var msid = $('#dwFileUpload').data("data-MSID");
    PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
}

function onFail_deleteFileDBEntry(value, ctx, methodName) {
    sendtoErrorPage("Error in trailerOverview.aspx, onFail_deleteFileDBEntry");
}

function onSuccess_addFileDBEntry(value, ctx, methodName) {
    var msid = $('#dwFileUpload').data("data-MSID");
    PageMethods.getFileUploadsFromMSID(msid, onSuccess_getFileUploadsFromMSID, onFail_getFileUploadsFromMSID, msid);
}
function onFail_addFileDBEntry(value, ctx, methodName) {
    sendtoErrorPage("Error in trailerOverview.aspx, onFail_addFileDBEntry");
}

function onSuccess_getTimeslotsData(value, ctx, methodName) {
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
                }
            };

            var newHeader = createScheduleGridHeader(colCount, headerData, schedGridData);
            var dvTableHeader = $("#dwScheduleTableHeader");
            dvTableHeader.html("");
            dvTableHeader.append(newHeader);

            var newtable = createScheduleGrid(colCount, headerData, schedGridData, false);
            var dvTable = $("#dwScheduleTable");
            dvTable.html("");
            dvTable.append(newtable);

            <%--setup for highlighting selected--%>
            var selSpot = $("#cboxSpot").igCombo("value");
            var newTime = $("#txtETATIME").igEditor("option", "value");
            var timeblock = $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').data("timeblock");

            if (timeblock) { <%--highlight cells within a timeblock--%>
                var splitHr = newTime.split(":");
                var hr = splitHr[0];
                var min = splitHr[1];

                var cellDateTime = new Date(1900, 0, 1, hr, min, 0);
                var EndBlockTime = new Date(1900, 0, 1, hr, min, 0);
                EndBlockTime.setTime(EndBlockTime.getTime() + (timeblock * 60 * 60 * 1000));

                while (cellDateTime < EndBlockTime) {
                    var newTime = ("00" + cellDateTime.getHours()).slice(-2) + ":" + ("00" + cellDateTime.getMinutes()).slice(-2);
                    $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').removeClass(); <%--remove all classes on cell--%>
                    $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').addClass("cell_Selected").addClass("cell_Available")
                    cellDateTime.setTime(cellDateTime.getTime() + (0.5 * 60 * 60 * 1000));<%--30 min increments--%>
                }
            }
            else { <%--highlight only single cell--%>
                $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').removeClass(); <%--remove all classes on cell--%>
                $('td[data-hour="' + newTime + '"][data-spotID="' + selSpot + '"]').addClass("cell_Selected").addClass("cell_Available")
            }
            var MSID = $("#grid").data("data-MSID");
            var selDateText = $("#dpETADATE").igEditor("text");
            if (MSID != -1) { <%--edit row--%>
                var record = $("#grid").igGrid("findRecordByKey", MSID);
                $("#dwSchedulePOLabel").text(" PO: " + record.PONUM + " DATE: " + selDateText);
            }
            else { <%--adding new row--%>
                var po = $("#grid").data("data-PONUM");
                $("#dwSchedulePOLabel").text(" PO: " + po + " DATE: " + selDateText);
            }
            $("#dwSchedule").igDialog("open");
        }

        function onFail_getTimeslotsData(value, ctx, methodName) {
            sendtoErrorPage("Error in trailerOverview.aspx, onFail_getTimeslotsData");
        }

        <%-------------------------------------------------------
        Click Handlers
        -------------------------------------------------------%>
        function clearTruckScheduleGridFilter(evt, ui) {
            $("#grid").igGridFiltering("filter", [], true);
        }
        function onclick_ShowAllScheduledTrucks(evt, ui) {
            clearTruckScheduleGridFilter()
        }
        function onclick_ShowTodaysScheduledTrucks(evt, ui) {

            clearTruckScheduleGridFilter();

            var todayDate = new Date();
            $("#grid").igGridFiltering("filter",
                [{ fieldName: "ETADATE", expr: todayDate.toDateString(), cond: "on" }],
                true);
        }
        function onclick_ShowOpenInCMSButOutOfPlant(evt, ui) {
            clearTruckScheduleGridFilter();
            $("#grid").igGridFiltering("filter",
                [{ fieldName: "boolCMSOPEN", expr: true, cond: "true" },
                { fieldName: "LOCSHORT", expr: "NOS", cond: "equals" },
                { fieldName: "STATID", expr: 10, cond: "equals" }
                ],
                true);
        }

        function onclick_OrderTruck(evt, ui) {
            var jsonRowData = $("#grid").data("newRowJSONData");
            insertNewSchedule(jsonRowData);
            $("#dwCMSProdDetails").igDialog("close");
        }
        function onclick_CancelOrderTruck(evt, ui) {
            $("#grid").data("newRowJSONData", "");
            $("#dwCMSProdDetails").igDialog("close");
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
                timeblock = timeblock * 60 <%--convert to min--%>
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
                <%--find cell matching and--%>

                var newtime = ("00" + cellDate.getHours()).slice(-2) + ":" + ("00" + cellDate.getMinutes()).slice(-2);
                var isNotAvailable = $('td[data-hour="' + newtime + '"][data-spotID="' + spotID + '"]').hasClass("cell_notAvailable");
                if (isNotAvailable) {
                    isValidBlock = false;
                }
                cellDate = new Date(cellDate.getTime() + 30 * 60000); <%--add 30 min--%>

            }
            if (isValidBlock) {
                var response = confirm("Select " + startHour + " at spot " + spotName + " for appointment? ")
                if (response) {
                    var selSpot = $("#cboxSpot").igCombo("value", spotID);
                    var newTime = $("#txtETATIME").igEditor("option", "value", startHour);

                    $("#dwSchedule").igDialog("close");
                }
            }
            else {
                alert("Not a valid time block. Please select a different time.");
            }
        }

        function onclick_addFile(fupID) {
            $(fupID).click();
        }
        function onclick_deleteFile(fid) {
            r = confirm("Continue removing this file from the truck data? This cannot be undone.")
            if (r) {
                var fileTypeAndID = ["OTHER", fid];
                PageMethods.deleteFileDBEntry(fid, "OTHER", onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, fileTypeAndID);
            }
        }
        function onclick_deleteBOL() {
            r = confirm("Continue removing the BOL from the truck data? This cannot be undone.")
            if (r) {
                var fileTypeAndID = ["BOL", fid];
                var fid = $('#dBOLcontainer').data("data-fileID");
                PageMethods.deleteFileDBEntry(fid, "BOL", onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, fileTypeAndID);
            }
        }
        function onclick_deleteCOFA() {
            r = confirm("Continue removing the COFA from the truck data? This cannot be undone.")
            if (r) {
                var fileTypeAndID = ["COFA", fid];
                var fid = $('#dCOFAcontainer').data("data-fileID");
                PageMethods.deleteFileDBEntry(fid, "COFA", onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry, fileTypeAndID);
            }
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

            $("#igUploadBOL").igUpload({
                autostartupload: true,
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileSelecting: function (evt, ui) { },
                fileSelected: function (evt, ui) { showProgress(); },
                fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                    var ctxVal = [];
                    var MSID = $("#dwFileUpload").data("data-MSID");
                    ctxVal[0] = ui.filePath;
                    ctxVal[1] = "BOL";
                    ctxVal[2] = MSID;
                    PageMethods.processFileAndData(ui.filePath, "BOL", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                    hideProgress();
                },
                fileUploadedAborted: function (evt, ui) {
                    hideProgress();
                },
                onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in trailerOverview.aspx, igUploadBOL"); },

            });
            $("#igUploadCOFA").igUpload({
                autostartupload: true,
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileSelecting: function (evt, ui) { },
                fileSelected: function (evt, ui) { showProgress(); },
                fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                    var ctxVal = [];
                    var MSID = $("#dwFileUpload").data("data-MSID");
                    ctxVal[0] = ui.filePath;
                    ctxVal[1] = "COFA";
                    ctxVal[2] = MSID;
                    PageMethods.processFileAndData(ui.filePath, "COFA", onSuccess_processFileAndData, onFail_processFileAndData, ctxVal);
                    hideProgress();
                },
                fileUploadedAborted: function (evt, ui) {
                    hideProgress();
                },
                onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in trailerOverview.aspx, igUploadCOFA"); },
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
                onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in trailerOverview.aspx, igUploadOTHER"); },
            });

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


            $("#dwFileUpload").igDialog({
                width: "600px",
                height: "550px",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {
                        <%-- Delete attributes on controls --%>
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

            $("#dwCMSProdDetails").igDialog({
                width: "1025px",
                height: "600px",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {
                        hideVolumeValidationMsgs();
                    }
                }
            });
            $("#dwPODetails").igDialog({
                width: "600px",
                height: "300px",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
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

            $("#gridCOFAFiles").igGrid({
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
                { headerText: "CMS Product ID ", key: "CMSPRODUCTID", dataType: "string", width: "20%", },
                { headerText: "CMS Product Name ", key: "CMSPRODUCTNAME", dataType: "string", width: "20%", },
                { headerText: "Filename", key: "FNAMEOLD", dataType: "string", width: "30%", template: "<div><a href='${FPATH}\${FNAMENEW}'>${FNAMEOLD}</a></div>" },
                { headerText: "Description", key: "DESC", dataType: "string", width: "30%" },
                ]
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
                            enableDeleteRow: false, <%-- use clickable image since this only shows on row hover --%>
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
                                    onclick_addFile("#igUploadOTHER_ibb_fp");
                                }
                                else { <%-- // do nothing; regular row is being edited --%>

                                }
                            },
                            editRowEnded: function (evt, ui) {

                                <%-- change add new row's filename col back to blank column --%>
                                $("#gridFiles tr").eq(2).find('td:first-child').text("");

                                if (ui.rowAdding) { <%-- new row edited --%>
                                    if (!ui.update) {
                                        <%--do nothing --%>
                                    }
                                }
                                else { <%--regular row is being edited --%>
                                    <%--call update--%>
                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                    PageMethods.updateFileUploadData(row.FID, row.DESC, onSuccess_updateFileUploadData, onFail_updateFileUploadData);
                                }
                            },
                            columnSettings: [
                                { columnKey: "FNAMEOLD", readOnly: true },
                                { columnKey: "FUPDEL", readOnly: true },
                                { columnKey: "DESC", editorType: "text" },
                            ]
                        }
                    ]
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
                { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px", }
                ]
            });
            $("#gridCMSProdDetails").igGrid({
                dataSource: null,
                width: "1000px",
                virtualization: false,
                autoGenerateColumns: false,
                columns:
                [
                { headerText: "", key: "ISSALES", dataType: "boolean", width: "0px", },
                { headerText: "CMS Product Name ", key: "CMSPROD", dataType: "string", width: "200px", },
                { headerText: "Unit", key: "UNIT", dataType: "string", width: "50px", },
                { headerText: "Total Qty From CMS Orders", key: "QTYCMSORDERS", dataType: "number", width: "75px", },
                { headerText: "Qty From Selected PO", key: "QTYPONUM", dataType: "number", width: "75px", },
                { headerText: "Qty From Incoming Orders", key: "QTYLOADIN", dataType: "number", width: "75px", },
                { headerText: "Qty From Outgoing Sales", key: "QTYLOADOUT", dataType: "number", width: "75px", },
                { headerText: "Total Qty In CMS", key: "QTYCMSONHAND", dataType: "number", width: "75px", },
                { headerText: "Projected Volume After Order Using CMS Data", key: "PROJVOLUMEUSINGCMS", dataType: "number", width: "75px", },
                { headerText: "Total Qty In Tanks", key: "QTYONHAND", dataType: "number", width: "75px", },
                { headerText: "Projected Volume After Order Using Tank Data", key: "PROJVOLUMEUSINGTANK", dataType: "number", width: "75px", },
                { headerText: "Affected Future Orders (PO)", key: "AFFECTEDPO", dataType: "string", width: "100px", },
                ]
            });
           <%-- add grid cell click handler --%>
            $(document).delegate("#grid", "iggridcellclick", function (evt, ui) {
                if (ui.colKey === 'FUPLOAD' || ui.colKey === 'PONUM' || ui.colKey === 'PRODDETAIL') {
                    $("#grid").data("data-BUTTONClick", true);
                }
                else {
                    $("#grid").data("data-BUTTONClick", false);
                }
            });
            $("#dwSchedule").on("click", "td.cell_Available", onclick_availableCellClick);
            PageMethods.getLoadOptions(onSuccess_getLoadOptions, onFail_getLoadOptions);
            PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
            PageMethods.isUserPermittedToEdit(onSuccess_isUserPermittedToEdit, onFail_isUserPermittedToEdit);

        }); <%--end $(function () --%>

    </script>

    <%-----------------------------------------------------------%>
    <%--HTML SECTION--%>
    <%-----------------------------------------------------------%>
    <div>
        <h3>Lock Schedule Editing: </h3>
        <div>
            <input type="checkbox" id="chkCanEditSchedule" name="Edit" value="scheduleEditable" checked>
            Uncheck if you would like to edit the schedule for trucks that are on-site.
        </div>
    </div>
    <br />
    <br />
    <div class="dvGridFilterButtons">
        <button type="button" onclick='onclick_ShowAllScheduledTrucks(); return false;'>Show All Trucks</button>
        <button type="button" onclick='onclick_ShowTodaysScheduledTrucks(); return false;'>Show Today's Trucks</button>
        <button type="button" onclick='onclick_ShowOpenInCMSButOutOfPlant(); return false;'>Show Released Trucks but Open In CMS</button>
    </div>
    <br />
    <table id="grid"></table>
    <div id="igUploadBOL" style='display: none;'></div>
    <div id="igUploadCOFA" style='display: none;'></div>
    <div id="igUploadOTHER" style='display: none;'></div>
    <%-----------------------------------------------------------%>
    <%--DIALOG WINDOWS --%>
    <%-----------------------------------------------------------%>
    <%-- dialog for file upload--%>
    <div id="dwFileUpload">
        <table class="ContentExtend">
            <tr>
                <td>BOL:</td>
                <td>
                    <div>
                        <div id="dBOLcontainer" data-fileid="" style='float: left'><a id="alinkBOL"></a></div>
                        <div style='float: right'>
                            <div id='dDelBOL'>
                                <img src='Images/xclose.png' onclick='onclick_deleteBOL();return false;' height='16' width='16' />
                            </div>
                            <div id='dUpBOL' class='uploadBOL'>
                                <img src='Images/triangleDown.png' onclick='onclick_addFile("#igUploadBOL_ibb_fp");return false;' height='16' width='16' />
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <h3>COFA (view/download only):</h3>
        <div class="ContentExtend">
            <table id="gridCOFAFiles" class="ContentExtend"></table>
        </div>
        <h3>Other Files:</h3>
        <div class="ContentExtend">
            <table id="gridFiles" class="ContentExtend"></table>
        </div>
    </div>
    <%--dialog for product details before adding new row --%>
    <div id="dwCMSProdDetails">
        <table id="gridCMSProdDetails"></table>
        <br />
        <br />
        <div style="color: red">
            <div id="msgWarningHeader">
                Please proceed with caution if ordering the truck due to the reason(s) stated below:<br />
                <br />
            </div>
            <div id="msgOverCMSMax">
                - The maximum quantity allowed as stated in CMS will be reached.
                <br />
            </div>
            <div id="msgOverCMS90">
                - 90% of the maximum quantity allowed as stated in CMS will be reached.
                <br />
            </div>
            <div id="msgOverCMS80">
                - 80% of the maximum quantity allowed as stated in CMS will be reached.
                <br />
            </div>
            <div id="msgOverTankMax">
                - The maximum tank capacity allowed will be reached.
                <br />
            </div>
            <div id="msgOverTank90">
                - 90% of the maximum tank capacity allowed will be reached
                <br />
            </div>
            <div id="msgOverTank80">
                - 80% of the maximum tank capacity allowed will be reached.
                <br />
            </div>
            <div id="msgMultipleTanks">
                - The validation includes multiple tanks where the products in this order can be placed into. Volume may have to be divided into multiple tanks.
                <br />
            </div>
            <div id="msgNoTanks">
                - This order cannot be verified because it contains products that are not associated with any tanks.
                <br />
            </div>
            <div id="msgMultipleProducts">
                - The order cannot be verified because atleast one multi-product tank was included in the calculation.
                <br />
            </div>
            <div id="msgMissingCMSorTankData">
                - The order could not be verified because there is missing data from CMS or the tanks setup.
                <br />
            </div>
            <div id="msgNegativeAmount">
                - The order will result in negative quantities in either CMS or the tank. Please make sure you are ordering the correct truck.
                <br />
            </div>
            <div id="msgNoProductInformation">
                - The order could not be verified because there is no product under the selected order.
                <br />
            </div>
            <div id="msgAffectedPO">
                - This order may affect future orders that currently exist in the system. Please make sure to update these existing orders as needed.
                <br />
            </div>
            <div id="msgWarningFooter">
                <br />
                Please use your judgement when choosing to continue your truck order.
                <br />
            </div>
        </div>
        <div class="Mi4_Right">
            <input type="button" value="Order Truck" onclick="onclick_OrderTruck(); return false;" />
            <input type="button" value="Cancel Order Truck" onclick="onclick_CancelOrderTruck(); return false;" />
        </div>
    </div>

    <%-- dialog for schedule selection--%>
    <div id="dwSchedule" style="position: relative">
        <div id="dwScheduleDiv1">
            Click a cell to choose a time and spot for
            <div id="dwSchedulePOLabel"></div>
        </div>
        <div id="dwScheduleTableHeader"></div>
        <div id="dwScheduleTable"></div>
    </div>

    <%--dialog for PO details --%>
    <div id="dwPODetails">
        <h2><span>PO:     <span id="dvPODetailsPONUM"></span></span></h2>
        <h2><span>MSID:     <span id="spPODetailsMSID"></span></span></h2>
        <h2><span>Trailer Number:     <span id="spPODetailsTrailerNum"></span></span></h2>
        <h2><span>Customer:     <span id="spPODetailsCustomer"></span></span></h2>
    </div>
    <div id="dwProductDetails">
        <h2><span>PO:     <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>
    <div class="logWindow">
        <div class="logTitleBar">
            <div id="logButton">
                <div id="tLogMax" style="display: none">
                    <img src='Images/tLogMaxi.png' id="maxiIcon" />
                </div>
                <div id="tLogMini">
                    <img src='Images/tLogMini.png' id="miniIcon" />
                </div>
            </div>
            Truck Log
        </div>
        <div id="logTableWrapper">
            <input id="cboxLogTruckList" />
            <div id="tableLog"></div>
        </div>
    </div>

</asp:Content>
