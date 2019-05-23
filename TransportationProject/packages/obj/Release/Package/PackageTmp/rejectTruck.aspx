<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="rejectTruck.aspx.cs" Inherits="TransportationProject.rejectTruck" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Reject Truck</h2>
    <h3>Reject a truck</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_GRID_DATA = [];
        var GLOBAL_REJECT_DECISION = false;
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_IS_MOBILE_VIEWING;

        <%-------------------------------------------------------
        Pagemethods Handlers
        //-------------------------------------------------------%>



        function openProductDetailDialog(MSID) {
            var PO = $("#grid").igGrid("getCellValue", MSID, "PO");
            var trailer = $("#grid").igGrid("getCellValue", MSID, "TRAILER");
            var POTrailer = comboPOAndTrailer(PO, trailer);
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
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_getPODetailsFromMSID");
        }

        function onSuccess_getGridData(value, ctx, methodName) {
            if (value) {
                var productString = "";
                for (var i = 0; i < value.length; i++) {
                    var isOpenInCMS;
                    isOpenInCMS = formatBoolAsYesOrNO(value[i][6]);

                    GLOBAL_GRID_DATA.push({
                        "MSID": value[i][0], "PO": value[i][1], "TRAILER": value[i][2], "LOCATION": value[i][3],
                        "isREJECTED": value[i][4], "REJECTEDCOMMENT": value[i][5], "isOpenInCMS": isOpenInCMS, "PRODCOUNT": value[i][7], "PRODID": value[i][8], "PRODDETAIL": value[i][9]
                    });
                }
            }
            if (GLOBAL_IS_MOBILE_VIEWING == true) {
                initMobileGrid();
            }
            else {
                initGrid();
            }
        }

        function onFail_getGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in rejectTruck.aspx, onFail_getGridData");
        }

        function onSuccess_rejectATruck(returnTimeStamp, MSID, methodName) {
            var comment = $("#commentDialog").val();
            //var rejComment = $("#rejectDialog").data("data-rejectComment");
            PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
            if (returnTimeStamp) {
                //var rejComment = $("#rejectDialog").data("data-rejectComment");
                ////var comment = $("#commentDialog").html(); 

                if (GLOBAL_IS_MOBILE_VIEWING != true) {
                    var comboEditor = $("#grid").igGridUpdating("editorForKey", "REJECTEDCOMMENT");
                    comboEditor.igCombo("text", comment);
                }
                //                $("#grid").igGridUpdating("setCellValue", MSID, 'REJECTEDCOMMENT', rejComment);
                $("#grid").igGridUpdating("setCellValue", MSID, 'isREJECTED', returnTimeStamp);
                //$("#grid").igGridUpdating("setCellValue", MSID, 'REJECTEDCOMMENT', comment);
                $("#grid").igGrid("commit");
                //$("#rejectDialog").data("data-rejectComment", "");
                //PageMethods.getGridData(onSuccess_getGridData, onFail_getGridData);
            }
            if (checkNullOrUndefined(comment) == false) {
                PageMethods.setRejectionComment(MSID, comment, onSuccess_setRejectionComment, onFail_setRejectionComment, comment);
            }
        }

        function onFail_rejectATruck(value, ctx, methodName) {
            sendtoErrorPage("Error in rejectTruck.aspx, onFail_rejectTruck");
        }

        function onSuccess_undoARejectTruck(value, MSID, methodName) {
            $("#grid").igGridUpdating("setCellValue", MSID, 'isREJECTED', null);
            $("#rejectDialog").igDialog("close");// must close because it doesnt wait for response. if they didnt want to undo the reject, they will have to reopen dialog box
            $("#grid").igGrid("commit");
            PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
        }

        function onFail_undoARejectTruck(value, ctx, methodName) {
            sendtoErrorPage("Error in rejectTruck.aspx, onFail_undoARejectTruck");
        }

        function onSuccess_checkCurrentStatus_reject(currentLocStatus, MSID, methodName) {
            if (currentLocStatus) {
                var loc = currentLocStatus[0];
                var stat = currentLocStatus[1];
                var isRejected = currentLocStatus[2];
                var rejTime;
                if (currentLocStatus[3] != 0) {
                    rejTime = currentLocStatus[3]
                }
                else {
                    rejTime = "N/A";
                }
                var bypassConfirm = false;

                var PO = $("#grid").igGrid("getCellValue", MSID, "PO");

                if (loc == 'NOS') {
                    alert("Truck is no longer on site and its can no longer be rejected.");
                }
                else {
                    if (stat == 'Waiting For Sample Result' && isRejected == 'false') {
                        var c = confirm("There is a pending sample result. Would you like to continue rejecting the truck?");
                    }
                    else {
                        bypassConfirm = true;
                    }
                    if (c == true || bypassConfirm == true) {
                        $("#grid").data("data-MSID", MSID);
                        var isRejecting = $("#grid").data("data-rejecting");

                        var PO = $("#grid").igGrid("getCellValue", MSID, "PO");
                        var trailer = $("#grid").igGrid("getCellValue", MSID, "TRAILER");
                        var prodCount = $("#grid").igGrid("getCellValue", MSID, "PRODCOUNT");
                        var rejectedComment = $("#grid").igGrid("getCellValue", MSID, "REJECTEDCOMMENT");

                        $("#MSIDDialog").html("MSID: " + MSID);
                        $("#PODialog").html("PO: " + PO);

                        if (prodCount < 2) {
                            var product = $("#grid").igGrid("getCellValue", MSID, "PRODID");
                            //product = formatProductsForDialogBox(product);
                            $("#productsDialog").html("Product: " + product);
                            $('#prodButtonInRejectDialog').hide();
                            $('#prodButtonInRejectDialog').data('data-MSID', null);
                        }
                        else {
                            $("#productsDialog").html("Products: ");
                            $('#prodButtonInRejectDialog').show();
                            $('#prodButtonInRejectDialog').data('data-MSID', MSID);
                        }



                        //$("#productsDialog").html("Product: " + products);
                        $("#trailerDialog").html("Trailer Number: " + trailer);
                        $("#lblRejectTimeDialog").html("Rejected Time: " + rejTime);
                        $("#commentDialog").html(rejectedComment);


                        if (isRejected == true && loc != 'NOS') { //if rejected and onsite
                            $("#btnUpdate").show();
                            $("#btnSave").hide();
                            $("#btnCancel").show();
                            $("#undoRejectDialog").show();
                        }
                        else if (isRejected == true && loc == 'NOS') { //if rejected and NOS
                            $("#btnUpdate").hide();
                            $("#btnSave").hide();
                            $("#btnCancel").hide();
                            $("#undoRejectDialog").show();
                        }
                        else { //if not rejected
                            $("#btnUpdate").hide();
                            $("#btnSave").show();
                            $("#btnCancel").show();
                            $("#undoRejectDialog").hide();
                        }

                        $("#rejectDialog").igDialog("open");

                        $("#rejectDialog").data("data-loc", loc);
                        $("#rejectDialog").data("data-stat", stat);


                    }
                }
            }
        }

        function onSuccess_checkCurrentStatus_undoReject(value, MSID, methodName) {
            if (value) {
                var PO = $("#grid").igGrid("getCellValue", MSID, "PO");

                if (value == 'NOS') {
                    alert("Truck is no longer on site. The rejection can not be undone.");
                }
                else {
                    var reply = confirm("You are about to unreject PO: " + PO + " . Would you like to continue?");
                    if (reply) {
                        PageMethods.undoARejectedTruck(MSID, onSuccess_undoARejectTruck, onFail_undoARejectTruck, MSID);
                        //alert("undo reject");
                    }
                }
            }
        }

        function onFail_checkCurrentStatus(value, ctx, methodName) {
            sendtoErrorPage("Error in rejectTruck.aspx, onFail_checkCurrentStatus");
        }

        function onSuccess_setRejectionComment(value, comment, methodName) {
            //if (GLOBAL_IS_MOBILE_VIEWING == true) {
            var MSID = $("#grid").data("data-MSID");
            $("#grid").igGridUpdating("setCellValue", MSID, 'REJECTEDCOMMENT', comment);
            // }
            $("#grid").igGrid("commit");
        }

        function onFail_setRejectionComment(value, ctx, methodName) {
            sendtoErrorPage("Error in rejectTruck.aspx, onFail_setRejectionComment");
        }

        function formatProductsForDialogBox(products) {
            var list = products.split(",");
            var list2 = [];
            var commaCount = (products.match(/,/g) || []).length;

            if (commaCount > 2) {
                for (var i = 0; i < 3; i++) {
                    list2.push(list[i]);
                }
                list2.push("...");
            }
            else {
                list2 = products;
            }
            return list2;
        }



        function undoReject(MSID) {
            PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_undoReject, onFail_checkCurrentStatus, MSID);
        }

        function rejectTruck(MSID) {
            PageMethods.checkCurrentStatus(MSID, onSuccess_checkCurrentStatus_reject, onFail_checkCurrentStatus, MSID);
        }
        function onclick_btnUpdateRejectCommentDialog() {
            var comment = $("#commentDialog").val();
            if (checkNullOrUndefined(comment) == true) {
                alert("You must enter the reason for the truck being rejected before rejecting the truck.");
                return;
            }
            else {
                var MSID = $("#grid").data("data-MSID");
                PageMethods.setRejectionComment(MSID, comment, onSuccess_setRejectionComment, onFail_setRejectionComment, comment);
                $("#rejectDialog").igDialog("close");
            }

        }
        function onclick_btnConfirmRejectDialog() {
            var comment = $("#commentDialog").val();
            if (checkNullOrUndefined(comment) == true) {
                alert("You must enter the reason for the truck being rejected before rejecting the truck.");
                return;
            }
            else {
                var MSID = $("#grid").data("data-MSID");
                var hasRejectedTS = $("#lblRejectTimeDialog").val().replace("Rejected Time: ", "");
                PageMethods.rejectATruck(MSID, onSuccess_rejectATruck, onFail_rejectATruck, MSID);
                // $("#rejectDialog").data("data-rejectComment", comment);
                $("#rejectDialog").igDialog("close");
            }
        }
        function onclick_btnCancelDialog() {
            $("#grid").igGrid("commit");
            $("#rejectDialog").igDialog("close");
        }
        function onclick_UndoReject() {
            $("#rejectDialog").igDialog("close");
            var MSID = $("#grid").data("data-MSID");
            undoReject(MSID);
        }
        function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }

        function onFail_getLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in guardStation.aspx onFail_getLogDataByMSID");
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

            PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
            PageMethods.getGridData(onSuccess_getGridData, onFail_getGridData);

            $("#rejectDialog").igDialog({
                minWidth: "300px",
                minHeight: "300px",
                maxHeight: "75%",
                state: "closed",
                resizable: false,
                modal: true,
                draggable: false,
                showCloseButton: true,
                stateChanging: function (evt, ui) {
                }
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
                { headerText: "CMS Product ID ", key: "CMSPROD", dataType: "string", width: "150px", },
                { headerText: "CMS Product Name", key: "CMSPRODNAME", dataType: "string", width: "150px", },
                { headerText: "QTY", key: "QTY", dataType: "number", width: "150px", },
                { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px", },

                ]
            });
            $('#prodButtonInRejectDialog').click(function () {
                var MSID = $('#prodButtonInRejectDialog').data('data-MSID');
                openProductDetailDialog(MSID);
            });
        }); <%--end $(function () --%>


        <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
        function findAndApplyFilterFromInspections() {
             <%--filtering from when coming from inspection page on button click --%>
            var MSID = sessionStorage.getItem("MSID");
            if (checkNullOrUndefined(MSID) == false) {
                $("#grid").igGridFiltering("filter", ([{
                    fieldName: "MSID",
                    expr: MSID,
                    cond: "equals"
                }]), true);
                sessionStorage.setItem('MSID', "");<%--reset filter --%>
            }
        }

        function initGrid() {
            $("#grid").igGrid({
                dataSource: GLOBAL_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "90px" },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "45px" },
                        { headerText: "PO", key: "PO", dataType: "string", width: "90px" },
                        { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
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
                        {
                            headerText: "Rejected", key: "isREJECTED", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "175px",
                            template: "{{if(checkNullOrUndefined(${isREJECTED})) === true}} <div class ='ColumnContentExtend'> <input id='btnReject' type='button' value='Reject Truck' onclick='rejectTruck(${MSID});' class='ColumnContentExtend'/></div>" + "{{elseif (checkNullOrUndefined(${isREJECTED})) === false }} <div class ='ColumnContentExtend'>${isREJECTED} <span class='Mi4_undoIcon' onclick='undoReject(${MSID})'></span> </div>{{/if}}"
                        },
                        { headerText: "Reason for Rejection (max. 250 characters)", key: "REJECTEDCOMMENT", dataType: "string", width: "150px" }

                    ],
                features: [
                     {
                         name: 'Updating',
                         enableAddRow: false,
                         editMode: "row",
                         enableDeleteRow: false,
                         autoCommit: false,
                         editCellStarting: function (evt, ui) {
                             $("#grid").data("data-MSID", ui.rowID);
                             var row = ui.owner.grid.findRecordByKey(ui.rowID);
                             if ("isREJECTED" === ui.columnKey) {
                                 ui.keepEditing = false;
                                 return false;
                             }
                         },
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
                                 PageMethods.setRejectionComment(ui.values.MSID, ui.values.REJECTEDCOMMENT, onSuccess_setRejectionComment, onFail_setRejectionComment, ui.values.REJECTEDCOMMENT);
                                 PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
                             }
                             else {
                                 return false;
                             }
                         },
                         columnSettings:
                             [
                                  { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                      { columnKey: "PRODCOUNT", readOnly: true },
                                      { columnKey: "PRODID", readOnly: true },
                                      { columnKey: "PRODDETAIL", readOnly: true },
                                 { columnKey: "isREJECTED", readOnly: true },
                                 {
                                     columnKey: "REJECTEDCOMMENT",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 250,
                                     }
                                 }
                             ],
                     },
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

            findAndApplyFilterFromInspections()
        } <%--end of initGrid--%>



        function initMobileGrid() {
            $("#grid").igGrid({
                dataSource: GLOBAL_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [
                         { headerText: "Is open in CMS", key: "isOpenInCMS", width: "0px", hidden: true },
                        { headerText: "MSID", key: "MSID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "PO", key: "PO", dataType: "string", width: "90px" },
                        { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
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
                         {
                             headerText: "Rejected", key: "isREJECTED", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "175px",
                             template: "{{if(checkNullOrUndefined(${isREJECTED})) === true}} <div class ='ColumnContentExtend'> <input id='btnReject' type='button' value='Reject Truck' onclick='rejectTruck(${MSID});' class='ColumnContentExtend'/></div>" + "{{elseif (checkNullOrUndefined(${isREJECTED})) === false }} <div class ='ColumnContentExtend'>${isREJECTED} <span class='Mi4_undoIcon' onclick='undoReject(${MSID})'></span> </div>{{/if}}"
                         },
                        { headerText: "Reason for Rejection (max. 250 characters)", key: "REJECTEDCOMMENT", dataType: "string", width: "150px" }

                    ],
                features: [
                     {
                         name: 'Updating',
                         enableAddRow: false,
                         editMode: "row",
                         enableDeleteRow: false,
                         autoCommit: false,
                         editCellStarting: function (evt, ui) {
                             $("#grid").data("data-MSID", ui.rowID);
                         },
                         editRowStarting: function (evt, ui) {
                             var row = ui.owner.grid.findRecordByKey(ui.rowID);
                             var trailerDialog = "";
                             $("#MSIDDialog").html("MSID: " + ui.rowID);
                             $("#grid").data("data-MSID", ui.rowID);
                             $("#PODialog").html("PO: " + row.PO);
                             if (checkNullOrUndefined(row.TRAILER) == true) { trailerDialog = ""; }
                             else { trailerDialog = row.TRAILER }
                             $("#trailerDialog").html("Trailer: " + trailerDialog);
                             var prodCount = $("#grid").igGrid("getCellValue", MSID, "PRODCOUNT");
                             var rejectedComment = $("#grid").igGrid("getCellValue", MSID, "REJECTEDCOMMENT");

                             $("#MSIDDialog").html("MSID: " + MSID);
                             $("#PODialog").html("PO: " + PO);

                             if (prodCount < 2) {
                                 var product = $("#grid").igGrid("getCellValue", MSID, "PRODID");
                                 $("#productsDialog").html("Product: " + product);
                                 $('#prodButtonInRejectDialog').hide();
                                 $('#prodButtonInRejectDialog').data('data-MSID', null);
                             }
                             else {
                                 $("#productsDialog").html("Products: ");
                                 $('#prodButtonInRejectDialog').show();
                                 $('#prodButtonInRejectDialog').data('data-MSID', MSID);
                             }
                             var rejectedTimeDialog = "";
                             if (checkNullOrUndefined(row.isREJECTED) == true) {
                                 rejectedTimeDialog = "";
                                 $("#undoRejectDialog").hide();
                                 $("#btnUpdate").hide();
                                 $("#btnSave").show();
                             }
                             else {
                                 var rejectDate = new Date(row.isREJECTED);
                                 rejectedTimeDialog = formatDate(rejectDate);
                                 $("#undoRejectDialog").show();
                                 $("#btnUpdate").show();
                                 $("#btnSave").hide();

                             }
                             $("#lblRejectTimeDialog").html("Rejected Time: " + rejectedTimeDialog);
                             $("#commentDialog").html(row.REJECTEDCOMMENT);

                             $("#rejectDialog").igDialog("open");

                             return false;

                         },
                         editRowEnding: function (evt, ui) {
                             var origEvent = evt.originalEvent;
                             if (typeof origEvent === "undefined") {
                                 ui.keepEditing = true;
                                 return false;
                             }
                             if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 PageMethods.setRejectionComment(ui.values.MSID, ui.values.REJECTEDCOMMENT, onSuccess_setRejectionComment, onFail_setRejectionComment, ui.values.REJECTEDCOMMENT);
                             }
                             else {
                                 return false;
                             }
                         },
                         columnSettings:
                             [
                                  { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                      { columnKey: "PRODCOUNT", readOnly: true },
                                      { columnKey: "PRODID", readOnly: true },
                                      { columnKey: "PRODDETAIL", readOnly: true },
                                 { columnKey: "isREJECTED", readOnly: true },
                                 {
                                     columnKey: "REJECTEDCOMMENT",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 250,
                                     }
                                 }
                             ],
                     },
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
            findAndApplyFilterFromInspections()
        } <%--end of initGrid--%>
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
    <table id="grid"></table>

    <div id="rejectDialog">
        <table style="border: 0;">
            <tr>
                <td>
                    <label id="MSIDDialog">MSID: </label>
                </td>
            </tr>
            <tr>
                <td>
                    <label id="PODialog">PO: </label>
                </td>
            </tr>
            <tr>
                <td>
                    <label id="trailerDialog">Trailer Number: </label>
                </td>
            </tr>
            <tr>
                <td>
                    <label id="productsDialog">Products: </label>
                </td>
                <td>
                    <input type='button' value='Multiple' id="prodButtonInRejectDialog">
                </td>
            </tr>
            <tr>
                <td>
                    <label id="lblRejectTimeDialog">Rejected Time: </label>
                </td>
                <td><span id="undoRejectDialog" class="Mi4_undoIcon" onclick="onclick_UndoReject()"></span></td>
            </tr>
            <tr>
                <td></td>
            </tr>
            <tr>
                <td>
                    <label>Comments:</label><textarea id="commentDialog" maxlength="250"></textarea></td>
            </tr>
            <tr>
                <td>
                    <button type="button" id="btnUpdate" onclick='onclick_btnUpdateRejectCommentDialog(); return false;'>Update Rejected Truck Comment</button>
                    <button type="button" id="btnSave" onclick='onclick_btnConfirmRejectDialog(); return false;'>Confirm Truck Rejection</button>
                    <button type="button" id="btnCancel" onclick='onclick_btnCancelDialog(); return false;'>Cancel</button>
                </td>
            </tr>
        </table>
    </div>
    <div id="dwProductDetails">
        <h2><span>PO - Trailer:  <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>
</asp:Content>
