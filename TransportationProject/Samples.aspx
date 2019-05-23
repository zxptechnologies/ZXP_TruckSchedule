<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Samples.aspx.cs" Inherits="TransportationProject.Samples" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Samples</h2>
    <h3>View, create, edit, and delete samples. Shows all the samples that are currently being processed and their status.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_LOAD_OPTIONS = [];
        var GLOBAL_LOCATION_OPTIONS = [];
        var GLOBAL_SAMPLEGRID_DATA = [];
        var GLOBAL_APPROVEREJECT_SAMPLEGRID_DATA = [];
        var GLOBAL_PO_OPTIONS = [];
        var GLOBAL_PRODUCT_OPTIONS = [];
        var GLOBAL_LABTEST_OPTIONS = [];
        var GLOBAL_TRAILER_OPTIONS = [];
        var GLOBAL_IS_MOBILE_VIEWING = false;
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS = [];
        var GLOBAL_SPOTS_OPTIONS = [];
        var GLOBAL_ISDIALOG_OPEN = false;



        <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>
         <%--//Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatLoadCombo(val) {
            var i, load;
            for (i = 0; i < GLOBAL_LOAD_OPTIONS.length; i++) {
                load = GLOBAL_LOAD_OPTIONS[i];
                if (load.LOAD == val) {
                    val = load.LABEL;
                }
            }
            return val;
        }

         <%--//Formatting for igGrid cells to display igCombo text as opposed to igCombo value; Remove Commas--%>
        function formatPOCombo(val) {
            var mystring = val
            mystring.replace(/,/g, "");
            return mystring;
        }


        function displayColumnBasedOnUser(userData) {
            if (userData) {//zxc                
                if ((userData._isInspector || userData._isLoader) && !(userData._isLabPersonnel || userData._isLabAdmin) ) {
                    $("#gridSamples").igGrid("hideColumn", "FILEUPLOAD");
                    $("#gridSamples").igGridResizing("resize", "FILEUPLOAD", "0px");
                    $("#gridSamples").igGrid("hideColumn", "TESTID");
                    $("#gridSamples").igGridResizing("resize", "TESTID", "0px");
                    $("#gridSamples").igGrid("hideColumn", "TRESULT");
                    $("#gridSamples").igGridResizing("resize", "TRESULT", "0px");


                    $("#gridSamples").igGrid("hideColumn", "SRECVTIME");
                    $("#gridSamples").igGridResizing("resize", "SRECVTIME", "0px");
                    $("#gridSamples").igGrid("hideColumn", "COMMENTS");
                    $("#gridSamples").igGridResizing("resize", "COMMENTS", "0px");
                    $("#gridSamples").igGrid("hideColumn", "RESAMPLE");
                    $("#gridSamples").igGridResizing("resize", "RESAMPLE", "0px");
                    $("#gridSamples").igGrid("hideColumn", "COFAdetails");
                    $("#gridSamples").igGridResizing("resize", "COFAdetails", "0px");


                    $("#ApproveRejectGridSamples").igGrid("hideColumn", "FILEUPLOAD");
                    $("#ApproveRejectGridSamples").igGridResizing("resize", "FILEUPLOAD", "0px");
                    $("#ApproveRejectGridSamples").igGrid("hideColumn", "TESTID");
                    $("#ApproveRejectGridSamples").igGridResizing("resize", "TESTID", "0px");
                    $("#ApproveRejectGridSamples").igGrid("hideColumn", "TRESULT");
                    $("#ApproveRejectGridSamples").igGridResizing("resize", "TRESULT", "0px");
                    $("#ApproveRejectGridSamples").igGrid("hideColumn", "SRECVTIME");
                    $("#ApproveRejectGridSamples").igGridResizing("resize", "SRECVTIME", "0px");
                    $("#ApproveRejectGridSamples").igGrid("hideColumn", "COMMENTS");
                    $("#ApproveRejectGridSamples").igGridResizing("resize", "COMMENTS", "0px");
                    $("#ApproveRejectGridSamples").igGrid("hideColumn", "RESAMPLE");
                    $("#ApproveRejectGridSamples").igGridResizing("resize", "RESAMPLE", "0px");
                    $("#ApproveRejectGridSamples").igGrid("hideColumn", "COFAdetails");
                    $("#ApproveRejectGridSamples").igGridResizing("resize", "COFAdetails", "0px");
                }
                else if ((userData._isLabPersonnel || userData._isLabAdmin) && !(userData._isInspector || userData._isLoader)) {
                    $("#gridSamples").igGrid("hideColumn", "STAKENTIME");
                    $("#gridSamples").igGridResizing("resize", "STAKENTIME", "0px");
                    $("#gridSamples").igGrid("hideColumn", "SSENTTIME");
                    $("#gridSamples").igGridResizing("resize", "SSENTTIME", "0px");
                }
                else {
                      <%--show everything --%>
                  }
             }

         }
         <%-------------------------------------------------------
        Button Click Handlers
        -------------------------------------------------------%>
        function template_canBeApproveORDenied(SampleID) {
            for (var i = 0; i < GLOBAL_SAMPLEGRID_DATA.length; i++) {
                if (GLOBAL_SAMPLEGRID_DATA[i].SAMPLEID == SampleID) {
                    if ((checkNullOrUndefined(GLOBAL_SAMPLEGRID_DATA[i].BYPASSCOMMENT) == false) || (checkNullOrUndefined(GLOBAL_SAMPLEGRID_DATA[i].FILENAME) == false)) {
                        return true;
                    }
                    else {
                        return false;
                    }
                }
            }
        }

        function onclick_btnUpdateLocation() {
            var MSIDofSelectedTruck = $("#cboxTruckList").igCombo("value");
            var newLocation = $("#cboxLocations").igCombo("value");
            var dSpot = $("#cboxDockSpots").igCombo("value");
            if ((newLocation == 'DOCKVAN' || newLocation == 'DOCKBULK') && checkNullOrUndefined(dSpot) == true) {
                alert("You must specify which dock spot you want to move to. ");
            }
            else {
                PageMethods.getCurrentLocationAndStatus(MSIDofSelectedTruck, onSuccess_getCurrentLocationAndStatus_OnUpdate, onFail_getCurrentLocationAndStatus, MSIDofSelectedTruck);
            }
        }

        function onclick_btncloseLocation() {
            $("#locationOptionsWrapper").hide();
            $("#locationLabelWrapper").hide();
            $(".dvGridFilterButtons").show();
        }

        function onclick_btnApproveBypassDialog() {
            var canBypass = $("#gridSamples").data("data-isLabAdmin");
            var comment = $("#commentDialog").val();
            var hasComment = checkNullOrUndefined(comment);
            if (canBypass == true) {
                if (hasComment == false) {
                    var sampleID = $("#COFAdetailsDialog").data("data-SampleID");
                    var MSID = $("#COFAdetailsDialog").data("data-MSID");
                    PageMethods.bypassCOFA(sampleID, 0, comment, MSID, onSuccess_bypassCOFA, onFail_bypassCOFA, MSID);
                }
                else {
                    alert("You must enter a comment before COFA can be bypassed.");
                }
            }
            else {
                var lAdminUserName = $("#txtLabAdminUN").val();
                var lAdminPassword = $("#txtLabAdminPassword").val();
                PageMethods.checkLabAdminCredentials(lAdminUserName, lAdminPassword, onSuccess_checkLabAdminCredentials, onFail_checkLabAdminCredentials);
            }
        }

        function onclick_btnCancelBypassDialog() {
            $("#commentDialog").val('');
            $("#txtLabAdminPassword").val('');
            $("#txtLabAdminUN").val('');
            $("#COFAdetailsDialog").igDialog("close");
        }

        function onclick_btnSaveEditDialog() {
            var rowID = $("#editDialog").data("data-SampleID");
            var comments = $("#commentEditDialog").val();
            PageMethods.updateCommentLotusIDAndGravity(rowID, comments, null, null, onSuccess_updateCommentLotusIDAndGravity, onFail_updateCommentLotusIDAndGravity);
            $("#editDialog").igDialog("close");
        }

        function onclick_btnCancelEditDialog() {
            $("#editDialog").igDialog("close");
        }

        function onclick_dialogButtonClick(buttonType, timeType) {
            var rowID = $("#editDialog").data("data-SampleID");
            var MSID = $("#gridSamples").igGrid("getCellValue", rowID, "MSID");
            switch (timeType) {
                case "taken":
                    if (buttonType == "undo") {
                        undoSampleTake(MSID, rowID);
                    }
                    else {
                        $("#gridSamples").data("data-MSID", MSID);
                        $("#gridSamples").data("data-SampleID", rowID);
                        PageMethods.getCurrentLocationAndStatus(MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus, MSID);
                    }
                    break;
                case "sent":
                    if (buttonType == "undo") {
                        undoSampleSent(MSID, rowID);
                    }
                    else {
                        var PO = $("#gridSamples").igGrid("getCellValue", rowID, "PO");
                        var product = $("#gridSamples").igGrid("getCellValue", rowID, "PRODUCT");
                        onclick_sampleSent(MSID, rowID, PO, product);
                    }
                    break;
                case "received":
                    if (buttonType == "undo") {
                        undoSampleReceive(MSID, rowID);
                    }
                    else {
                        var PO = $("#gridSamples").igGrid("getCellValue", rowID, "PO");
                        var product = $("#gridSamples").igGrid("getCellValue", rowID, "PRODUCT");
                        onclick_sampleReceived(MSID, rowID, PO, product);
                    }
                    break;
            }

        }
        function onclick_addCOFA() {
            var SampleID = $("#COFAdetailsDialog").data("data-SampleID");
            sessionStorage.setItem('sampleID', SampleID);
            location.href = 'COFAUpload.aspx';
        }

        function onclick_COFAdetails(SampleID, grid) {
            var selectedGrid;
            if (grid == 'Pending') {
                selectedGrid = "#gridSamples";
            }
            else if (grid == 'RejAprv') {
                selectedGrid = "#ApproveRejectGridSamples";
            }


            $("#COFAdetailsDialog").data("data-SampleID", SampleID);
            var FileID = $(selectedGrid).igGrid("getCellValue", SampleID, "FILEID");
            $("#COFAdetailsDialog").data("data-FileID", FileID);

            var FUPLOAD = $(selectedGrid).igGrid("getCellValue", SampleID, "FUPLOAD");
            $("#COFAdetailsDialog").data("data-SampleID", FUPLOAD);

            var FileName = $(selectedGrid).igGrid("getCellValue", SampleID, "FILENAME");
            $("#COFAdetailsDialog").data("data-FileName", FileName);
            
            var byPasser = $(selectedGrid).igGrid("getCellValue", SampleID, "BYPASSER");
            $("#COFAdetailsDialog").data("data-ByPasser", byPasser);

            $("#commentDialog").val('');
            $("#txtLabAdminPassword").val('');
            $("#txtLabAdminUN").val('');
            $("#trLabAdminUserName").show();
            $("#trLabAdminUserPass").show();
            $("#commentDialog").attr("disabled", false);
            var canBypass = $("#gridSamples").data("data-isLabAdmin");

            var MSID = $(selectedGrid).igGrid("getCellValue", SampleID, "MSID");
            var PO = $(selectedGrid).igGrid("getCellValue", SampleID, "PO");
            var trailer = $(selectedGrid).igGrid("getCellValue", SampleID, "TRAILER");
            var products = $(selectedGrid).igGrid("getCellValue", SampleID, "PRODUCT");
            var bypassComment = $(selectedGrid).igGrid("getCellValue", SampleID, "BYPASSCOMMENT");

            //$("#sampleIDDialog").html("Sample ID: " + SampleID);
            $("#COFAdetailsDialog").data("data-SampleID", SampleID);
            //$("#MSIDDialog").html("MSID: " + MSID);
            $("#COFAdetailsDialog").data("data-MSID", MSID);
            $("#PODialog").html("PO: " + PO);
            $("#trailerDialog").html("Trailer: " + trailer);
            $("#productDialog").html("Product: " + products);
            $("#commentDialog").html(bypassComment);

            if (canBypass) {
                $("#lblLabAdminUN").hide();
                $("#txtLabAdminUN").hide();
                $("#lblLabAdminPassword").hide();
                $("#txtLabAdminPassword").hide();
            }
            else {
                $("#lblLabAdminUN").show();
                $("#txtLabAdminUN").show();
                $("#lblLabAdminPassword").show();
                $("#txtLabAdminPassword").show();
            }
            //<div id="COFAfile" data-fileID='${FILEID}' style='text-align: center'><a id='alinkCOFA' href='${FUPLOAD}'>${FILENAME}</a></div>
            if (grid == 'Pending') {
                if (FileID != null) {
                    $("#COFAfileDialog").data("data-fileID", FileID);
                    $("#alinkCOFADialog").attr('href', FUPLOAD);
                    $("#alinkCOFADialog").text(FileName);
                    $("#COFAstatus").text("COFA: ");
                    $("#COFAstatus").show();
                    $("#btnUpCOFADialog").hide();
                    $("#COFAfileDialog").show();
                    $("#bypassBtnSave").hide();
                }
                else {
                    if (byPasser) {
                        $("#COFAstatus").text("Bypassed by: " + byPasser);
                        $("#COFAstatus").show();
                        $("#btnUpCOFADialog").hide();
                        $("#COFAfileDialog").hide();
                        $("#bypassBtnSave").hide();
                    }
                    else {
                        $("#bypassBtnSave").show();
                        $("#COFAstatus").hide();
                        $("#btnUpCOFADialog").show();
                        $("#COFAfileDialog").hide();
                    }
                }
            }
            else {
                $("#bypassBtnSave").hide();
                $("#trLabAdminUserName").hide();
                $("#trLabAdminUserPass").hide();
                $("#commentDialog").attr("disabled", true);
                if (FileID != null) {
                    $("#COFAfileDialog").data("data-fileID", FileID);
                    $("#alinkCOFADialog").attr('href', FUPLOAD);
                    $("#alinkCOFADialog").text(FileName);
                    $("#btnUpCOFADialog").hide();
                    $("#COFAstatus").text("COFA: ");
                    $("#COFAstatus").show();
                    $("#COFAfileDialog").show();
                }
                else {
                    if (byPasser) {
                        $("#COFAstatus").text("Bypassed by: " + byPasser);
                        $("#COFAstatus").show();
                    }
                    else {
                        $("#COFAstatus").hide();
                    }
                    $("#btnUpCOFADialog").hide();
                    $("#COFAfileDialog").hide();
                }
            }




            $("#COFAdetailsDialog").igDialog("open");
        }

        function onclick_preApproveTest(MSID, SampleID, PO, Product) {
            var gravity = $("#gridSamples").igGrid("getCellValue", SampleID, "GRAVITY");
            var testID = $("#gridSamples").igGrid("getCellValue", SampleID, "TESTID");

            if ((checkNullOrUndefined(gravity)) && (checkNullOrUndefined(testID))) {
                alert("Specific Gravity and Lotus ID must be filled out before sample can be approved. Please fill them out and try again.")
            }
            else if ((checkNullOrUndefined(gravity)) && (!checkNullOrUndefined(testID)))
            {
                alert("Specific Gravity must be filled out before sample can be approved. Please fill it out and try again.")
            }
            else if ((!checkNullOrUndefined(gravity)) && (checkNullOrUndefined(testID))) {
                alert("Lotus ID must be filled out before sample can be approved. Please fill it out and try again.")
            }
            else {
                onclick_approveTest(MSID, SampleID, PO, Product);
            }
        } 

        function onclick_approveTest(MSID, SampleID, PO, Product) {
            var reply = confirm("Approve Sample for PO: " + PO + " Product: " + String(Product).trim() + "?");
            if (reply) {
                showProgress();
                PageMethods.approveSample(MSID, SampleID, onSuccess_approveSample, onFail_approveSample, MSID);
            }
            $("#gridSamples").data("data-someButtonClicked", true);
        }


        function CreateRequestForReSample(sampleID, MSID, trailerNum, productID, productName, SampleID, PODetailsID) {
            var productString = productID.trim() + " - " + productName.trim();
            showProgress();
            PageMethods.CreateRequestForReSample(MSID, trailerNum, "Resample for " + productString, SampleID, PODetailsID, onSuccess_CreateRequestForReSample, onFail_CreateRequestForReSample, productString);
        }


        function onclick_rejectTest(MSID, SampleID, PO, Product) {
            var reply = confirm("Reject Sample for PO: " + PO + " Product: " + String(Product).trim() + "?");
            if (reply) {
                showProgress();
                PageMethods.rejectSample(MSID, SampleID, onSuccess_rejectSample, onFail_rejectSample, MSID);
            }
            $("#gridSamples").data("data-someButtonClicked", true);
        }
        function onclick_sampleTaken(MSID, SampleID) {
            $("#gridSamples").data("data-MSID", MSID);
            $("#gridSamples").data("data-SampleID", SampleID);

            $("#gridSamples").data("data-someButtonClicked", true);
            PageMethods.getCurrentLocationAndStatus(MSID, onSuccess_getCurrentLocationAndStatus, onFail_getCurrentLocationAndStatus, MSID);
        }
        function onclick_sampleSent(MSID, SampleID, PO, Product) {
            PageMethods.sentProductSample(MSID, SampleID, onSuccess_sentProductSample, onFail_sentProductSample, MSID);
            $("#gridSamples").data("data-someButtonClicked", true);
        }

        function onclick_sampleReceived(MSID, SampleID, PO, Product) {
            PageMethods.receiveProductSample(MSID, SampleID, onSuccess_receiveProductSample, onFail_receiveProductSample, MSID);
            $("#gridSamples").data("data-someButtonClicked", true);
        }

        function undoSampleReceive(MSID, SampleID) {
            PageMethods.undoReceiveProductSample(MSID, SampleID, onSuccess_undoSampleReceive, onFail_undoSampleReceive, MSID);
            $("#gridSamples").data("data-someButtonClicked", true);
            $("#sentUndoEditDialog").show();
        }

        function undoSampleTake(MSID, SampleID) {
            PageMethods.undoTakeProductSample(MSID, SampleID, onSuccess_undoSampleTake, onFail_undoSampleTake, MSID);
            $("#gridSamples").data("data-someButtonClicked", true);
            $("#takenUndoEditDialog").hide();
            $("#btnSTakenEditDialog").show();
            $("#btnSSentEditDialog").hide();
            $("#sTakenTimeEditDialog").html("Sample Taken from Truck: ");

        }
        function undoSampleSent(MSID, SampleID) {
            PageMethods.undoSentProductSample(MSID, SampleID, onSuccess_undoSampleSent, onFail_undoSampleSent, MSID);
            $("#gridSamples").data("data-someButtonClicked", true);
            $("#sentUndoEditDialog").hide();
            $("#btnSSentEditDialog").show();
            $("#sSentTimeEditDialog").html("Sample Dropped at Lab: ");
        }

        function undoApproveTest(MSID, SampleID, PO, Product) {
            PageMethods.undoApproveSample(MSID, SampleID, onSuccess_undoApproveSample, onFail_undoApproveSample, MSID)
            $("#gridSamples").data("data-someButtonClicked", true);
        }
        function undoRejectTest(MSID, SampleID, PO, Product) {
            PageMethods.undoRejectSample(MSID, SampleID, onSuccess_undoRejectSample, onFail_undoRejectSample, MSID);
            $("#gridSamples").data("data-someButtonClicked", true);
        }

        function onSuccess_getCurrentLocationAndStatus(currentLocStatus, MSID, methodName) {
            var canSample = currentLocStatus[0];
            var locLong = currentLocStatus[1];
            var statLong = currentLocStatus[2];

            if (canSample) {
            //    var MSID = $("#gridSamples").data("data-MSID");
                var SampleID = $("#gridSamples").data("data-SampleID");
                PageMethods.takeProductSample(MSID, SampleID, onSuccess_takeProductSample, onFail_takeProductSample, MSID);
            }
            else {
                if (locLong == 'Guard Station' || locLong == 'Not On Site') {
                    alert("Sampling can not be done from " + locLong + ". Please update location and try again.");
                }
                else {
                    alert("Sample cannot be taken. PO's current status is " + statLong + ". Please complete this action before continuing taking sample.");
                }
            }
            $("#gridSamples").data("data-MSID", "");
            $("#gridSamples").data("data-SampleID", "");
        }

        function onSuccess_getCurrentLocationAndStatus_OnUpdate(currentLocStatus, MSIDofSelectedTruck, methodName) {
            if (currentLocStatus[3] == true) {
                var newLocation = $("#cboxLocations").igCombo("value");
                var dSpot = $("#cboxDockSpots").igCombo("value");
                if (newLocation == 'DOCKVAN' || newLocation == 'DOCKBULK') {
                    PageMethods.updateLocation(MSIDofSelectedTruck, newLocation, dSpot, onSuccess_updateLocation, onFail_updateLocation, MSIDofSelectedTruck);
                }
                else {
                    PageMethods.updateLocation(MSIDofSelectedTruck, newLocation, 0, onSuccess_updateLocation, onFail_updateLocation, MSIDofSelectedTruck);
                }
            }
            else {
                var selectedTruck = $("#cboxTruckList").igCombo("text");
                alert(selectedTruck + " has a current status of " + currentLocStatus[2] + " and is not eligible to move. Please finish this action in order to move the truck.");
            }
        }
        function onFail_getCurrentLocationAndStatus(value, ctx, methodName) {
            sendtoErrorPage("Error in Samples.aspx, onFail_getCurrentLocationAndStatus");
        }

        function onSuccess_GetLogDataByMSID(returnValue, MSID, methodName) {
            truckLog_OnSuccess_Render(returnValue, MSID);
        }
        function onFail_GetLogDataByMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in Samples.aspx onFail_GetLogDataByMSID");
        }

        function onSuccess_CreateRequestForReSample(returnValue, productString, methodName) {
            hideProgress();
            if (returnValue[0] == "true") {
                alert("The request for the resampling of " + productString + " and its sample has been successfully created.");
            }
            else {
                alert("Creating the resampling request and its sample has failed due to " + returnValue[1]);
            }
            PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);

        }
        function onFail_CreateRequestForReSample(value, ctx, methodName) {
            sendtoErrorPage("Error in Samples.aspx onFail_CreateRequestForReSample");
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
            sendtoErrorPage("Error in Samples.aspx, onFail_getRequestTypeBasedOnMSID");
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
            sendtoErrorPage("Error in Samples.aspx onFail_GetLogList");
        }
        function onSuccess_updateCommentLotusIDAndGravity(value, ctx, methodName) {
            PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
        }
        function onFail_updateCommentLotusIDAndGravity(value, ctx, methodName) {
            sendtoErrorPage("Error in Samples.aspx, onFail_updateCommentLotusIDAndGravity");
        }
        function onSuccess_undoApproveSample(value, MSID, methodName) {
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }
         function onFail_undoApproveSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_undoApproveSample");
         }
         function onSuccess_undoRejectSample(value, MSID, methodName) {
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }
         function onFail_undoRejectSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_undoRejectSample");
         }
         function onSuccess_rejectSample(value, ctx, methodName) {
             <%--reload datagrid --%>
             hideProgress();
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData, ctx);
         }
         function onFail_rejectSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_rejectSample");
         }
         function onSuccess_approveSample(value, ctx, methodName) {
             hideProgress();
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData, ctx);
             //PageMethods.GetLogDataByMSID(ctx, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ctx);
         }

         function onFail_approveSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_approveSample");
         }
         function onSuccess_undoSampleSent(value, MSID, methodName) {
             $("#takenUndoEditDialog").show();
             $("#sentUndoEditDialog").hide();
             $("#btnSSentEditDialog").show();
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }
         function onFail_undoSampleSent(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_undoSampleSent");
         }
         function onSuccess_undoSampleTake(value, MSID, methodName) {
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }
         function onFail_undoSampleTake(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_undoSampleTake");
         }
         function onSuccess_undoSampleReceive(value, MSID, methodName) {
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }
         function onFail_undoSampleReceive(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_undoSampleReceive");
         }
        function onSuccess_takeProductSample(value, ctx, methodName) {
            
            var url_string = window.location.href;
            var url = new URL(url_string);
            var MSIDRedirect = url.searchParams.get("MSID");
            if (MSIDRedirect) {
                var param = "MSID=" + MSIDRedirect;
                var redirect = "loaderMobile.aspx?" + param;
                window.location = redirect;
            }

            $("#btnSTakenEditDialog").hide();
            $("#takenUndoEditDialog").show();
            $("#btnSSentEditDialog").show();
            $("#sTakenTimeEditDialog").html(formatDate(value));
            <%--reload datagrid --%>
            PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
            //PageMethods.GetLogDataByMSID(ctx, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ctx);
         }
         function onFail_takeProductSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_takeProductSample");
         }
         function onSuccess_sentProductSample(value, MSID, methodName) {
             $("#btnSSentEditDialog").hide();
             $("#sentUndoEditDialog").show();
             $("#takenUndoEditDialog").hide();
             $("#sSentTimeEditDialog").html(formatDate(value));
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }
         function onFail_sentProductSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_sentProductSample");
         }
         function onSuccess_receiveProductSample(value, MSID, methodName) {
             $("#sentUndoEditDialog").hide();
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }
         function onFail_receiveProductSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_receiveProductSample");
         }
         function onSuccess_createSample(value, MSID, methodName) {
             <%--reload datagrid --%>
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData, MSID);
         }
         function onFail_createSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_createSample");
         }
         function onSuccess_getPODetailProductsFromMSID(value, ctx, methodName) {
             GLOBAL_PRODUCT_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_PRODUCT_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
             }
             $("#cboxProduct").igCombo("option", "dataSource", GLOBAL_PRODUCT_OPTIONS);
             $("#cboxProduct").igCombo("dataBind");
         }

         function onFail_getPODetailProductsFromMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, getPODetailProductsFromMSID");
         }
         function onSuccess_GetLoadOptions(value, ctx, methodName) {
             GLOBAL_LOAD_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_LOAD_OPTIONS[i] = { "LOAD": value[i][0], "LABEL": value[i][1] };
             }
             PageMethods.getAvailablePOForSamplesGridOptions(onSuccess_getAvailablePOForSamplesGridOptions, onFail_getAvailablePOForSamplesGridOptions);

             //PageMethods.getAvailableLabSamplesFromLotusNotes(onSuccess_getAvailableLabSamplesFromLotusNotes, onFail_getAvailableLabSamplesFromLotusNotes);
         }
         function onFail_GetLoadOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_GetLoadOptions");
         }
         //function onSuccess_getAvailableLabSamplesFromLotusNotes(value, ctx, methodName) {
         //    GLOBAL_LABTEST_OPTIONS.length = 0;
         //    for (i = 0; i < value.length; i++) {
         //        GLOBAL_LABTEST_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
         //    }
         //}
         //function onFail_getAvailableLabSamplesFromLotusNotes(value, ctx, methodName) {
         //    sendtoErrorPage("Error in Samples.aspx, onFail_getAvailableLabSamplesFromLotusNotes");
         //}
         function onSuccess_GetLocationOptions(returnValue, MSID, methodName) {
             GLOBAL_LOCATION_OPTIONS = [];
             for (i = 1; i < returnValue.length; i++) { <%--start at one to not add current location--%>
                 GLOBAL_LOCATION_OPTIONS.push({ "LOC": returnValue[i][0], "LOCTEXT": returnValue[i][1] });
             }
             $("#cboxLocations").igCombo("option", "dataSource", GLOBAL_LOCATION_OPTIONS);
             $("#cboxLocations").igCombo("dataBind");

             <%--set current location on label --%>
             if (returnValue[0][0] == 'GS') {
                 $("#lblLocation").html("Current Location: Guard Station  (NOTE: Sampling can not be done in Guard Station)");
             }
             else {
                 var currentLocation = returnValue[0][1]
                 $("#cboxLocations").igCombo("value", returnValue[0][0]);

                 if (returnValue[0][0] == 'DOCKVAN' || returnValue[0][0] == 'DOCKBULK') {
                     $("#dockSpotOptionsWrapper").show();
                     currentLocation = currentLocation + " " + returnValue[0][3]
                 }
                 $("#lblLocation").html("Current Location: " + currentLocation);
             }
             $("#lblStatus").html("Current Status: " + returnValue[0][2]);

             PageMethods.getAvailableDockSpots(MSID, onSuccess_getAvailableDockSpots, onFail_getAvailableDockSpots, MSID);
         }

         function onFail_GetLocationOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_GetLocationOptions");
         }

         function onSuccess_getAvailablePOForSamplesGridOptions(value, ctx, methodName) {
             GLOBAL_PO_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_PO_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
             }
             PageMethods.getCurrentTrailers(onSuccess_getCurrentTrailers, onFail_getCurrentTrailers);

         }
         function onSuccess_getAvailablePOForSamplesGridOptions_Rebind(value, ctx, methodName) {
             GLOBAL_PO_OPTIONS = [];
             for (i = 0; i < value.length; i++) {
                 GLOBAL_PO_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
             }
             $("#cboxPO").igCombo("option", "dataSource", GLOBAL_PO_OPTIONS);
             $("#cboxPO").igCombo("dataBind");
             PageMethods.getCurrentTrailers(onSuccess_getCurrentTrailers_Rebind, onFail_getCurrentTrailers);
         }

         function onFail_getAvailablePOForSamplesGridOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_getAvailablePOForSamplesGridOptions");
         }

         function onSuccess_getCurrentTrailers(value, ctx, methodName) {
             GLOBAL_TRAILER_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_TRAILER_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
             }

             PageMethods.getSampleGridData(onSuccess_getSampleGridData, onFail_getSampleGridData);
             //PageMethods.getUserData(onSuccess_getUserData, onFail_getUserData);
         }

         function onSuccess_getCurrentTrailers_Rebind(value, ctx, methodName) {//asd
             GLOBAL_TRAILER_OPTIONS = [];
             for (i = 0; i < value.length; i++) {
                 GLOBAL_TRAILER_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
             }
             $("#cboxTrailer").igCombo("option", "dataSource", GLOBAL_TRAILER_OPTIONS);
             $("#cboxTrailer").igCombo("dataBind");
             //$("#gridSamples").igGrid("dataBind");
         }

         function onFail_getCurrentTrailers(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_getCurrentTrailer");
         }

        function onSuccess_getUserData(userInfo, ctx, methodName) {
            if (GLOBAL_IS_MOBILE_VIEWING === true) {
            showProgress();
                 initMobileGrid();
                 $("#cboxTruckList").attr("disabled", true);
                 $("#cboxLocations").attr("disabled", true);
                 $("#cboxDockSpots").attr("disabled", true);

                 $("#lbl_Loc").addClass("mobileLbl");
                 $("#lbl_dockSposts").addClass("mobileLbl");
                 $("#lblLocation").addClass("mobileLbl");
                 $("#lblStatus").addClass("mobileLbl");
                $("#apprvRejLabel").hide();
                hideProgress();
             }
            else {
                initGrid();
             }
             if (userInfo._isLabAdmin == true) {
                 $("#gridSamples").data("data-isLabAdmin", true);
             }
             else {
                 $("#gridSamples").data("data-isLabAdmin", false);
             }

             displayColumnBasedOnUser(userInfo);
             checkForRedirect();
             $("#dvGridSamples").show();

            PageMethods.getApprovedAndRejectedSampleGridData(onSuccess_getApprovedAndRejectedSampleGridData, onFail_getApprovedAndRejectedSampleGridData);
            
         }

         function onFail_getUserData(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_getUserData");
         }


         function onSuccess_getSampleGridData(value, ctx, methodName) {
             GLOBAL_SAMPLEGRID_DATA = [];

             for (i = 0; i < value.length; i++) {
                 var bypasserName;
                 var isOpenInCMS;
                 if (checkNullOrUndefined(value[i][17]) == true) {
                     bypasserName = "";
                 }
                 else {
                     bypasserName = value[i][17] + " " + value[i][18];
                 }

                 isOpenInCMS = formatBoolAsYesOrNO(value[i][20]);
                 GLOBAL_SAMPLEGRID_DATA[i] = {
                           "MSID": value[i][0], "PODETAILID": value[i][1], "PO": value[i][2], "PRODUCT": value[i][3],
                     "FILEID": value[i][4], "FILEPATH": value[i][5], "FILENAME": value[i][6],
                     "FUPLOAD": value[i][5] + "/" + value[i][14], "SAMPLEID": value[i][7], "SAMPLEIDTEXT": value[i][7], "TESTID": value[i][8],
                     "TRESULT": value[i][15], "STAKENTIME": value[i][9], "SSENTTIME": value[i][10],
                     "SRECVTIME": value[i][11], "COMMENTS": value[i][13], "TRAILER": value[i][16],
                     "BYPASSER": bypasserName, "BYPASSCOMMENT": value[i][19], "GRAVITY": value[i][20], "isOpenInCMS": isOpenInCMS, "REJECTED": value[i][22],
                     "PRODUCTDETAILS": value[i][23], "RESAMPLE": "", "COFADetails": ""
                 };
             }
             $("#gridSamples").igGrid("option", "dataSource", GLOBAL_SAMPLEGRID_DATA);
             $("#gridSamples").igGrid("dataBind");
             PageMethods.getUserData(onSuccess_getUserData, onFail_getUserData);
         }

         function onSuccess_getSampleGridDataRebind(value, ctx, methodName) {
             GLOBAL_SAMPLEGRID_DATA.length = 0;

             for (i = 0; i < value.length; i++) {
                 var bypasserName;
                 var isOpenInCMS;
                 if (checkNullOrUndefined(value[i][17]) == true) {
                     bypasserName = "";
                 }
                 else {
                     bypasserName = value[i][17] + " " + value[i][18];
                 }
                 isOpenInCMS = formatBoolAsYesOrNO(value[i][20]);

                 GLOBAL_SAMPLEGRID_DATA[i] = {
                    

                      "MSID": value[i][0], "PODETAILID": value[i][1], "PO": value[i][2], "PRODUCT": value[i][3],
                     "FILEID": value[i][4], "FILEPATH": value[i][5], "FILENAME": value[i][6],
                     "FUPLOAD": value[i][5] + "/" + value[i][14], "SAMPLEID": value[i][7], "SAMPLEIDTEXT": value[i][7], "TESTID": value[i][8],
                     "TRESULT": value[i][15], "STAKENTIME": value[i][9], "SSENTTIME": value[i][10],
                     "SRECVTIME": value[i][11], "COMMENTS": value[i][13], "TRAILER": value[i][16],
                     "BYPASSER": bypasserName, "BYPASSCOMMENT": value[i][19], "GRAVITY": value[i][20], "isOpenInCMS": isOpenInCMS, "REJECTED": value[i][22],
                     "PRODUCTDETAILS": value[i][23], "RESAMPLE": "", "COFADetails": ""
                 };
             }

             $("#gridSamples").igGrid("option", "dataSource", GLOBAL_SAMPLEGRID_DATA);
             $("#gridSamples").igGrid("dataBind");

             //change told combo box to all 
             $("#cboxTruckList").igCombo("value", -1);
             $("#locationOptionsWrapper").hide();
             $("#locationLabelWrapper").hide();
             //PageMethods.GetLogDataByMSID(ctx, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ctx);
             PageMethods.getApprovedAndRejectedSampleGridData(onSuccess_getApprovedAndRejectedSampleGridData, onFail_getApprovedAndRejectedSampleGridData);
         }

         function onFail_getSampleGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_getSampleGridData");
         }



         function onSuccess_getApprovedAndRejectedSampleGridData(value, ctx, methodName) {
             GLOBAL_APPROVEREJECT_SAMPLEGRID_DATA = [];

             for (i = 0; i < value.length; i++) {
                 var bypasserName;
                 var isOpenInCMS;
                 if (checkNullOrUndefined(value[i][17]) == true) {
                     bypasserName = "";
                 }
                 else {
                     bypasserName = value[i][17] + " " + value[i][18];
                 }

                 isOpenInCMS = formatBoolAsYesOrNO(value[i][20]);
                 GLOBAL_APPROVEREJECT_SAMPLEGRID_DATA[i] = {
                     "MSID": value[i][0], "PODETAILID": value[i][1], "PO": value[i][2], "PRODUCT": value[i][3],
                     "FILEID": value[i][4], "FILEPATH": value[i][5], "FILENAME": value[i][6],
                     "FUPLOAD": value[i][5] + "/" + value[i][13], "SAMPLEID": value[i][7], "SAMPLEIDTEXT": value[i][7], "TESTID": value[i][8],
                     "TRESULT": value[i][14], "STAKENTIME": value[i][9], "SSENTTIME": value[i][10],
                     "SRECVTIME": value[i][11], "COMMENTS": value[i][12], "TRAILER": value[i][15],
                     "BYPASSER": bypasserName, "BYPASSCOMMENT": value[i][18], "GRAVITY": value[i][19], "isOpenInCMS": isOpenInCMS, "REJECTED": value[i][21], "PRODUCTDETAILS": value[i][22], "RESAMPLE": "", "COFADetails": ""
                 };
             }
             $("#ApproveRejectGridSamples").igGrid("option", "dataSource", GLOBAL_APPROVEREJECT_SAMPLEGRID_DATA);
             $("#ApproveRejectGridSamples").igGrid("dataBind");
             hideProgress();

         }

         function onFail_getApprovedAndRejectedSampleGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_getApprovedAndRejectedSampleGridData");
         }
         function onSuccess_deleteSample(value, MSID, methodName) {
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);

         }

         function onFail_deleteSample(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_deleteSample");
         }

         function onSuccess_ProcessFileAndData(value, ctx, methodName) {
             if (ctx) {
                 if ("COFA" === ctx[1]) {
                     //Add entry into DB
                     PageMethods.AddFileDBEntry(ctx[2], "COFA", ctx[0], value[1], value[0], "COFA", ctx[3], onSuccess_AddFileDBEntry, onFail_AddFileDBEntry, ctx);
                 }
             }
         }

         function onFail_ProcessFileAndData(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_ProcessFileAndData");
         }

         function onSuccess_AddFileDBEntry(value, ctx, methodName) {
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData);
             hideProgress();
         }

         function onFail_AddFileDBEntry(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_AddFileDBEntry");
         }

         function onSuccess_checkLabAdminCredentials(labAdminUserID, ctx, methodName) {
             if (labAdminUserID == 0) { <%--if login has failed or user is not lab admin--%>
                 alert("Login has failed or login provided is not a lab admin");
             }
             else {
                 var comment = $("#commentDialog").val();
                 var hasComment = checkNullOrUndefined(comment);

                 if (hasComment == false) {<%--if there is a comment--%>
                     var sampleID = $("#COFAdetailsDialog").data("data-SampleID");
                     var MSID = $("#gridSamples").igGrid("getCellValue", sampleID, "MSID");
                     PageMethods.bypassCOFA(sampleID, labAdminUserID, comment, MSID, onSuccess_bypassCOFA, onFail_bypassCOFA);
                 }
                 else { <%--of there is not a comment--%>
                     alert("You must enter a comment before COFA can be bypassed.");
                 }
             }
         }

         function onFail_checkLabAdminCredentials(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_checkLabAdminCredentials");
         }

         function onSuccess_bypassCOFA(value, ctx, methodName) {
             PageMethods.getSampleGridData(onSuccess_getSampleGridDataRebind, onFail_getSampleGridData, ctx);
             $("#COFAdetailsDialog").igDialog("close");
             $("#commentDialog").val('');
             $("#txtLabAdminPassword").val('');
             $("#txtLabAdminUN").val('');

         }

         function onFail_bypassCOFA(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_bypassCOFA");
         }

         function onSuccess_getListofTrucksCurrentlyInZXP(value, ctx, methodName) {
             GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS = [];
             for (i = 0; i < value.length; i++) {
                 GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS[i] = { "MSID": value[i][0], "PO": String(value[i][1]) + "-" + $.trim(value[i][2]), "CURRENTLOCATION": value[i][3] };
             }
             GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS.unshift({ "MSID": -1, "PO": "(ALL)", "CURRENTLOCATION": null });

             $("#cboxTruckList").igCombo("option", "dataSource", GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS);
             $("#cboxTruckList").igCombo("dataBind");
             PageMethods.GetLoadOptions(onSuccess_GetLoadOptions, onFail_GetLoadOptions);
         }

         function onFail_getListofTrucksCurrentlyInZXP(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_getListofTrucksCurrentlyInZXP");
         }

         function onSuccess_updateLocation(value, MSIDofSelectedTruck, methodName) {//asd
             //PageMethods.GetLogDataByMSID(MSIDofSelectedTruck, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSIDofSelectedTruck);
             var newLocLong = $("#cboxLocations").igCombo("text");
             var dockSpot = $("#cboxDockSpots").igCombo("text");
             if (!checkNullOrUndefined(dockSpot)) {
                 newLocLong = newLocLong + " " + dockSpot;
             }


             //var newLocShort = $("#cboxLocations").igCombo("value");
             $("#lblLocation").html('Current Location: ' + newLocLong);
             $("#lblStatus").html("Current Status: " + value[0]);
             //$("#locationOptionsWrapper").hide();

             //update 'current status'
             for (var i = 0; i < GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS.length; i++) {
                 if (MSIDofSelectedTruck == GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS[i].MSID) {
                     GLOBAL_CURRENTLY_IN_ZXP_PO_OPTIONS[i].CURRENTLOCATION = newLocLong;
                     break;
                 }
             }
             PageMethods.getAvailablePOForSamplesGridOptions(onSuccess_getAvailablePOForSamplesGridOptions_Rebind, onFail_getAvailablePOForSamplesGridOptions);

         }

         function onFail_updateLocation(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_updateLocation");
         }

         function onSuccess_getSampleGridDataByMSID(value, ctx, methodName) {
             GLOBAL_SAMPLEGRID_DATA = [];

             for (i = 0; i < value.length; i++) {
                 var isOpenInCMS;
                 var bypasserName;
                 if (checkNullOrUndefined(value[i][17]) == true) {
                     bypasserName = "";
                 }
                 else {
                     bypasserName = value[i][17] + " " + value[i][18];
                 }
                 isOpenInCMS = formatBoolAsYesOrNO(value[i][20]);

                 GLOBAL_SAMPLEGRID_DATA[i] = {
                     "MSID": value[i][0], "PODETAILID": value[i][1], "PO": value[i][2], "PRODUCT": value[i][3],
                     "FILEID": value[i][4], "FILEPATH": value[i][5], "FILENAME": value[i][6],
                     "FUPLOAD": value[i][5] + "/" + value[i][13], "SAMPLEID": value[i][7], "SAMPLEIDTEXT": value[i][7], "TESTID": value[i][8],
                     "TRESULT": value[i][14], "STAKENTIME": value[i][9], "SSENTTIME": value[i][10],
                     "SRECVTIME": value[i][11], "COMMENTS": value[i][12], "TRAILER": value[i][15], "BYPASSER": bypasserName,
                     "BYPASSCOMMENT": value[i][18], "GRAVITY": value[i][19], "REJECTED": value[i][21], "isOpenInCMS": isOpenInCMS, "PRODUCTDETAILS": value[i][22], "RESAMPLE" : ""
                 };
             }
             $("#gridSamples").igGrid("option", "dataSource", GLOBAL_SAMPLEGRID_DATA);
             $("#gridSamples").igGrid("dataBind");

             //var MSIDofSelectedTruck = $("#cboxTruckList").igCombo("value");
             //var MSIDofSelectedTruck = $("#cboxTruckList").igCombo("text");

             //GLOBAL_PO_OPTIONS = [];
             //GLOBAL_PO_OPTIONS[i] = { "ID": value[i][0], "LABEL": value[i][1] };
         }

         function onFail_getSampleGridDataByMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx, onFail_getSampleGridData");
         }

         function onSuccess_getAvailableDockSpots(value, MSID, methodName) {
             GLOBAL_SPOTS_OPTIONS.length = 0;
             for (i = 0; i < value.length; i++) {
                 GLOBAL_SPOTS_OPTIONS[i] = { "SPOTID": value[i][0], "DOCKSPOT": value[i][1] };
             }
             $("#cboxDockSpots").igCombo("option", "dataSource", GLOBAL_SPOTS_OPTIONS);
             $("#cboxDockSpots").igCombo("dataBind");

             PageMethods.getCurrentDockSpot(MSID, onSuccess_getCurrentDockSpot, onFail_getCurrentDockSpot);
         }

         function onFail_getAvailableDockSpots(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx onFail_getAvailableDockSpots");
         }

         function onSuccess_getCurrentDockSpot(currentOrAssignedSpot, ctx, methodName) {
             //clear selection
             $("#cboxDockSpots").igCombo("value", null);

             // 0 = no spot, 3015 = Yard, & 3017 = Wait Area
             if (currentOrAssignedSpot != 0 && currentOrAssignedSpot != 3015 && currentOrAssignedSpot != 3017) {
                 $("#cboxDockSpots").igCombo("value", currentOrAssignedSpot);
             }
             hideProgress();
         }

         function onFail_getCurrentDockSpot(value, ctx, methodName) {
             sendtoErrorPage("Error in Samples.aspx onFail_getCurrentDockSpot");
         }


         function clearGridFilters(evt, ui) {
             $("#gridSamples").igGridFiltering("filter", []);
         }
         function onclick_ShowRejectedTrucks(evt, ui) {
             clearGridFilters();
             $("#gridSamples").igGridFiltering("filter",
                 [{ fieldName: "REJECTED", expr: true, cond: "true" }
                 ],
                 true);
         }

         function formatGravity(val) {
             if (val != null) {
                 return val.toFixed(4);
             }
             else {
                 return "";
             }
         }
         function initGrid() {
             $("#gridSamples").igGrid({
                 dataSource: GLOBAL_SAMPLEGRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 autofitLastColumn: true,
                 primaryKey: "SAMPLEID",
                 columns: [
                     
                    {
                        headerText: "Resample", key: "RESAMPLE", dataType: "string", width: "120px",
                        template: "{{if(!checkNullOrUndefined(${SRECVTIME}))}}<div class ='ColumnContentExtend'><input id='btnGridResample_${SAMPLEID}' type='button' value='Resample' onclick='GLOBAL_ISDIALOG_OPEN = true; clearGridFilters();CreateRequestForReSample(${SAMPLEID}, ${MSID}, \"${TRAILER}\", \"${PRODUCT}\", \"${PRODUCTDETAILS}\", \"${SAMPLEID}\", \"${PODETAILID}\" );' class='ColumnContentExtend'></div> " +
                            "{{else}}<div></div>{{/if}}"
                    },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                        { headerText: "Is open in CMS", key: "isOpenInCMS", dataType: "string", width: "0px" },
                    { headerText: "MSID", key: "MSID", dataType: "number", width: "0px" },
                    { headerText: "", key: "PODETAILID", dataType: "number", width: "0px", hidden: true },
                    { headerText: "", key: "FILEID", dataType: "number", width: "0px", hidden: true },
                    { headerText: "", key: "FILEPATH", dataType: "string", width: "0px", hidden: true },
                    { headerText: "", key: "FUPLOAD", dataType: "string", width: "0px", hidden: true },
                    { headerText: "", key: "FILENAME", dataType: "string", width: "0px", hidden: true },
                    { headerText: "", key: "SAMPLEID", dataType: "number", width: "0px", hidden: true },
                    { headerText: "Sample ID", key: "SAMPLEIDTEXT", dataType: "number", width: "0px" },
                    { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                    { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
                    { headerText: "Part Number", key: "PRODUCT", dataType: "string", width: "150px" },
                    { headerText: "Product", key: "PRODUCTDETAILS", dataType: "string", width: "150px" },
                    {
                        headerText: "Sample Taken from Truck", key: "STAKENTIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "110px",
                        template: "{{if (checkNullOrUndefined(${STAKENTIME}))===true}}<div class ='ColumnContentExtend'><input type='button' value='Sample Taken' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_sampleTaken(${MSID}, ${SAMPLEID});' class='ColumnContentExtend'></div>" +
                            "{{elseif (!checkNullOrUndefined(${STAKENTIME}) && checkNullOrUndefined(${SSENTTIME}))=== true}}<div class ='ColumnContentExtend'>${STAKENTIME}<span class='Mi4_undoIcon' onclick='GLOBAL_ISDIALOG_OPEN = true; undoSampleTake(${MSID}, ${SAMPLEID})'></span></div>" +
                            "{{else}}<div class ='ColumnContentExtend'>${STAKENTIME}</div>{{/if}}"
                    },
                    {
                        headerText: "Sample Dropped at Lab", key: "SSENTTIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "110px",
                        template: "{{if (!checkNullOrUndefined(${STAKENTIME}) && checkNullOrUndefined(${SSENTTIME}))===true}}<div class ='ColumnContentExtend'><input type='button' value='Sample Sent' onclick= 'GLOBAL_ISDIALOG_OPEN = true; onclick_sampleSent(${MSID},${SAMPLEID}, ${PO}, \"${PRODUCT}\");' class='ColumnContentExtend'></div>" +
                            "{{elseif (!checkNullOrUndefined(${STAKENTIME}) && !checkNullOrUndefined(${SSENTTIME}) && checkNullOrUndefined(${SRECVTIME}))=== true}}<div class ='ColumnContentExtend'>${SSENTTIME}<span class='Mi4_undoIcon' onclick='GLOBAL_ISDIALOG_OPEN = true; undoSampleSent(${MSID}, ${SAMPLEID})'></span></div>" +
                            "{{else}}<div class ='ColumnContentExtend'>${SSENTTIME}</div>{{/if}}"

                    },
                    {
                        headerText: "Sample Received by Lab", key: "SRECVTIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "110px",
                        template: "{{if (!checkNullOrUndefined(${STAKENTIME}) && !checkNullOrUndefined(${SSENTTIME}) && checkNullOrUndefined(${SRECVTIME}))===true}}<div class ='ColumnContentExtend'><input type='button' value='Sample Received' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_sampleReceived(${MSID},${SAMPLEID}, ${PO}, \"${PRODUCT}\");' class='ColumnContentExtend'></div>" +
                            "{{elseif (!checkNullOrUndefined(${STAKENTIME}) && !checkNullOrUndefined(${SSENTTIME})  && !checkNullOrUndefined(${SRECVTIME}))=== true && checkNullOrUndefined(${TRESULT}) === true}}<div class='ColumnContentExtend'>${SRECVTIME}<span class='Mi4_undoIcon' onclick='GLOBAL_ISDIALOG_OPEN = true; undoSampleReceive(${MSID}, ${SAMPLEID})'></span></div>" +
                            "{{elseif (!checkNullOrUndefined(${STAKENTIME}) && !checkNullOrUndefined(${SSENTTIME})  && !checkNullOrUndefined(${SRECVTIME})) && !checkNullOrUndefined(${TRESULT})}}<div class ='ColumnContentExtend'>${SRECVTIME}</div>" +
                            "{{else}}<div></div>{{/if}}"

                    },
                    { headerText: "Lotus Sample ID", key: "TESTID", dataType: "string", width: "60px", },
                    { headerText: "Specific Gravity", key: "GRAVITY", dataType: "number", width: "75px", formatter: formatGravity },
                    {
                        headerText: "Approve / Reject", key: "TRESULT", dataType: "number", width: "120px", template: "{{if(checkNullOrUndefined(${SRECVTIME}))}}<div></div>" +
                        "{{elseif (checkNullOrUndefined(${TRESULT}) && !checkNullOrUndefined(${SRECVTIME})) === true && template_canBeApproveORDenied(${SAMPLEID}) === true}}<div class='ColumnContentExtend'><span class='Mi4_CheckIcon' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_preApproveTest(${MSID}, ${SAMPLEID}, ${PO}, \"${PRODUCT}\")'></span><span class='Mi4_CrossIcon' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_rejectTest(${MSID}, ${SAMPLEID}, ${PO}, \"${PRODUCT}\")'></span></div>" +
                        "{{elseif (checkNullOrUndefined(${TRESULT}) && !checkNullOrUndefined(${SRECVTIME})) === true && template_canBeApproveORDenied(${SAMPLEID}) === false}}<div>COFA Upload or Bypass Required</div>" +
                        "{{elseif (${TRESULT})}}<div>APPROVED <span class='Mi4_undoIcon' onclick='GLOBAL_ISDIALOG_OPEN = true; undoApproveTest(${MSID}, ${SAMPLEID})'></span></div>" +
                        "{{else}}<div>REJECTED <span class='Mi4_undoIcon' onclick='GLOBAL_ISDIALOG_OPEN = true; undoRejectTest(${MSID}, ${SAMPLEID})'></span></div>{{/if}}"
                    },
                    {
                        headerText: "COFA Details", key: "COFADetails", dataType: "string", width: "100px",
                        template: "{{if (!checkNullOrUndefined(${SRECVTIME}))}}<div class ='ColumnContentExtend'><input id='btnCOFADetails_${SAMPLEID}' type='button' value='COFA Details' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_COFAdetails(${SAMPLEID},\"Pending\");' class='ColumnContentExtend'></div>" +
                            "{{else}} <div></div> {{/if}}"
                    },
                    { headerText: "Lab Comments (max. 250)", key: "COMMENTS", dataType: "string", width: "225px" },
                    {
                        headerText: "COFA", key: "FILEUPLOAD", dataType: "string", width: "0px", //<div style='background-color:lightcoral; width: 100%;'>
                        template: "{{if (checkNullOrUndefined(${BYPASSER}) === true  && checkNullOrUndefined(${FILENAME}) === true)}}<div class ='ColumnContentExtend'><input id='btnUpCOFA_${SAMPLEID}' type='button' value='Upload COFA' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_addCOFA(${SAMPLEID});' class='ColumnContentExtend'></div>" +
                        "{{elseif (checkNullOrUndefined(${BYPASSER}) === true  && !checkNullOrUndefined(${FILENAME})) === true}} <div data-fileID='${FILEID}' style='text-align: center'><a id='alinkCOFA' href='${FUPLOAD}'>${FILENAME}</a></div>{{/if}}"
                    },
                    {
                        headerText: "Bypass COFA", key: "BYPASSER", dataType: "string", width: "0px",
                        template: "{{if (checkNullOrUndefined(${BYPASSER}) === true  && checkNullOrUndefined(${FILENAME})) === true && (!checkNullOrUndefined(${SRECVTIME}))}}<div class ='ColumnContentExtend'><input id='btnBypassCOFA' type='button' value='Bypass COFA' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_COFAdetails(${SAMPLEID},\"Pending\");' class='ColumnContentExtend'></div>" +
                            "{{elseif (!checkNullOrUndefined(${BYPASSER}))}} Bypass approved by: ${BYPASSER} " +
                            "{{else}} <div></div> {{/if}}"
                    },
                    { headerText: "Bypass Comment (max. 250)", key: "BYPASSCOMMENT", dataType: "string", width: "0px" }

                 ],
                 //autofitLastColumn: true,
                 features: [
                 
                    {
                        name : 'Paging',
                        type: "local",
                        pageSize : 25
                    },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                         columnSettings: [
                                        { columnKey: 'STAKENTIME', condition: 'on' },
                                        { columnKey: 'SSENTTIME', condition: 'on' },
                                        { columnKey: 'SRECVTIME', condition: 'on' },
                                        { columnKey: 'REJECTED', allowFiltering: false },
                                        { columnKey: 'TRESULT', allowFiltering: false },
                                        { columnKey: 'FILEUPLOAD', allowFiltering: false },
                                        { columnKey: 'BYPASSER', allowFiltering: false },
                         ],
                         dataFiltering: function (evt, ui) {
                             var nExpressions = [];
                             for (i = 0; i < ui.newExpressions.length; i++) {
                                 var newcond = ui.newExpressions[i].cond;
                                 var newExpr = ui.newExpressions[i].expr;
                                 var newFieldName = ui.newExpressions[i].fieldName;
                                 if (!checkNullOrUndefined(newExpr)) {
                                     if (newFieldName.contains("STAKENTIME") || newFieldName.contains("SSENTTIME") || newFieldName.contains("SRECVTIME")) {
                                         ui.newExpressions[i].preciseDateFormat = null;
                                     }

                                     nExpressions.push(ui.newExpressions[i]);
                                 }

                             }
                             $("#gridSamples").igGridFiltering("filter", nExpressions);
                             return false;
                         }
                     },
                        {
                            name: "Updating",
                            editMode: "row",
                            enableAddRow: true,
                            enableDeleteRow: true, <%-- // use clickable image since this only shows on row hover --%>
                            rowEditDialogContainment: "owner",
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            editCellStarting: function (evt, ui) {
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                if (ui.rowAdding) {<%-- new row--%>
                                    if (//ui.columnKey === "STAKENTIME" || ui.columnKey === "SSENTTIME" || ui.columnKey === "SRECVTIME" ||
                                        ui.columnKey === "SAMPLEIDTEXT" || ui.columnKey === "TRESULT" || ui.columnKey === "TESTID" || ui.columnKey === "FILEUPLOAD"
                                        || ui.columnKey === "TRESULT" || ui.columnKey === "BYPASSER" || ui.columnKey === "BYPASSCOMMENT" || ui.columnKey === "GRAVITY") { <%-- disable--%>
                                        return false;
                                    } 
                                }
                                else { <%-- row edit --%>
                                    //if (!checkNullOrUndefined(row.SRECVTIME)) {
                                    //    return false;
                                    //}
                                    if (ui.columnKey === "SAMPLEIDTEXT" || ui.columnKey === "STAKENTIME" || ui.columnKey === "SSENTTIME" || ui.columnKey === "SRECVTIME" ||
                                        ui.columnKey === "PO" || ui.columnKey === "PRODUCT" || ui.columnKey === "FILEUPLOAD" || ui.columnKey === "TRESULT" || ui.columnKey === "TRAILER") {
                                        return false;
                                    }
                                    else if ((ui.columnKey === "TESTID" || ui.columnKey === "GRAVITY" || ui.columnKey === "COMMENTS") && (checkNullOrUndefined(row.SRECVTIME))) {
                                        return false;
                                    }
                                }
                            },
                            //editCellEnding: function (evt, ui) {
                            //    if (ui.value === "" || !ui.value) {
                            //        alert('Not a valid scoring number');
                            //        evt.stopPropagation();
                            //        evt.stopImmediatePropagation();
                            //        evt.preventDefault();
                            //        return false;
                            //    }

                            //    return true;
                            //},
                            editRowStarting: function (evt, ui) {
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                var isDisabledColClick = $("#gridSamples").data("data-disabledColsClick");
                                var isBtnClicked = $("#gridSamples").data("data-someButtonClicked");
                                var isCOFACommentClicked = $("#gridSamples").data("data-COFACOMMENTClick");
                                var isCommentClicked = $("#gridSamples").data("data-COMMENTClick");

                                <%--stop editing if button was clicked instead of cell entry for editing--%>
                                var isUploadBtnClicked = $("#gridSamples").data("data-BUTTONClick");
                                if (isUploadBtnClicked) {
                                    $("#gridSamples").data("data-BUTTONClick", false);
                                    return false;
                                }

                                if (!ui.rowAdding) {
                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                    //PageMethods.GetLogDataByMSID(row.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSID);

                                    <%--if (isCOFACommentClicked && checkNullOrUndefined(row.BYPASSCOMMENT) == true) { <%-- checks to see if 
                                        alert("You must first bypass a sample before you can add a bypass comment.");
                                        $("#gridSamples").data("data-COFACOMMENTClick", false); <%--reset-
                                        return false;
                                    }
                                    else --%>
                                        if (isCOFACommentClicked) {
                                        $("#gridSamples").data("data-COFACOMMENTClick", false); <%--reset--%>
                                    }

                                    if (checkNullOrUndefined(row.SRECVTIME) && GLOBAL_ISDIALOG_OPEN == false) {
                                        alert('You can not edit this row until the sample is marked as received by the lab.');
                                        return false;
                                    }
                                }
                                



                                if (isDisabledColClick || isBtnClicked) { <%-- end editing if time column btns were clicked, continue edit mode only when other cells are clicked --%>
                                    $("#gridSamples").data("data-disabledColsClick", false); <%--reset--%>
                                    $("#gridSamples").data("data-someButtonClicked", false);
                                    return false;
                                }
                            },


                            rowAdding: function (evt, ui) {
                                var origEvent = evt.originalEvent;
                                if (typeof origEvent === "undefined") {
                                    ui.keepEditing = true;
                                    return false;
                                }
                                if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) { //david
                                <%--send data to code behind --%>
                                    var rMSID = ui.values.PO;
                                    var rPODetailsID = ui.values.PRODUCT;
                                    var rComments = ui.values.COMMENTS;
                                    if (checkNullOrUndefined(rComments)) {
                                        rComments = null;
                                    }

                                    PageMethods.createSample(rMSID, rPODetailsID, rComments, onSuccess_createSample, onFail_createSample, rMSID);
                                    return false; <%--do to prevent infragistics javascript errors due to conditional template--%>
                                }
                                else {
                                    return false;
                                }

                            },
                            editRowEnding: function (evt, ui) {
                                if (!ui.rowAdding) {
                                    var origEvent = evt.originalEvent;
                                    if (typeof origEvent === "undefined") {
                                        return false;
                                    }
                                    if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                        PageMethods.updateCommentLotusIDAndGravity(ui.values.SAMPLEID, ui.values.COMMENTS, ui.values.TESTID, ui.values.GRAVITY, ui.values.BYPASSCOMMENT, onSuccess_updateCommentLotusIDAndGravity, onFail_updateCommentLotusIDAndGravity);
                                    }
                                    else {
                                        return false;
                                    }
                                }
                            },
                            rowDeleting: function (evt, ui) {
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);

                                var r = confirm("Continue deleting sample data for " + row.PO + " " + row.PRODUCT.trim() + "? Deletion cannot be undone.");
                                if (r === true) {
                                    var rSampleID = row.SAMPLEID;
                                    var rMSID = row.MSID;
                                    PageMethods.deleteSample(rSampleID, rMSID, onSuccess_deleteSample, onFail_deleteSample, rMSID);

                                }
                                else {
                                    return false;
                                }
                            },
                            columnSettings: [
                            { columnKey: "COFADetails", readOnly: true },
                            { columnKey: "BYPASSCOMMENT", readOnly: true },
                                { columnKey: "REJECTED", readOnly: true },
                                { columnKey: "PRODUCTDETAILS", readOnly: true },
                                { columnKey: "isOpenInCMS", readOnly: true },
                                { columnKey: "REJECT", readOnly: true },
                                { columnKey: "MSID", readOnly: true },
                                { columnKey: "PODETAILID", readOnly: true },
                                { columnKey: "FILEID", readOnly: true },
                                { columnKey: "FILEPATH", readOnly: true },
                                { columnKey: "SAMPLEID", readOnly: true },
                                { columnKey: "SAMPLEIDTEXT", readOnly: true },
                                { columnKey: "BYPASSER", readOnly: true },
                                {
                                    columnKey: "PO",
                                    editorType: "combo",
                                    required: true,
                                    editorOptions: {
                                        mode: "editable",
                                        enableClearButton: false,
                                        dataSource: GLOBAL_PO_OPTIONS,
                                        itemTemplate: "<span title=\"${LABEL}\">${LABEL}</span>",
                                        id: "cboxPO",
                                        textKey: "LABEL",
                                        valueKey: "ID",
                                        autoSelectFirstMatch: true,
                                        virtualization: true,
                                        dropDownOpening: function (evt, ui) {
                                            $("#cboxPO").igCombo("option", "dataSource", GLOBAL_PO_OPTIONS);
                                            $("#cboxPO").igCombo("dataBind");
                                            var currentlySelectedPO = $("#cboxTruckList").igCombo("value");
                                            if (currentlySelectedPO != -1) {
                                                $("#cboxPO").igCombo("value", currentlySelectedPO);
                                            }
                                        },
                                        selectionChanged: function (evt, ui) {
                                            if (ui.items.length > 0) {
                                                var MSID = ui.items[0].data.ID
                                                if (MSID) {
                                                    PageMethods.getPODetailProductsFromMSID(MSID, onSuccess_getPODetailProductsFromMSID, onFail_getPODetailProductsFromMSID);
                                                    var item = $("#cboxTrailer").igCombo("itemsFromValue", MSID);
                                                    if (!checkNullOrUndefined(item)) {
                                                        $("#cboxTrailer").igCombo("value", MSID);
                                                    }
                                                    else {
                                                        $("#cboxTrailer").igCombo("deselectAll");
                                                        $("#cboxProduct").igCombo("deselectAll");
                                                    }
                                                }
                                            }
                                        }
                                    },
                                },
                                {
                                    columnKey: "TRAILER",
                                    editorType: "combo",
                                    required: false,
                                    editorOptions: {
                                        mode: "editable",
                                        enableClearButton: false,
                                        dataSource: GLOBAL_TRAILER_OPTIONS,
                                        itemTemplate: "<span title=\"${LABEL}\">${LABEL}</span>",
                                        id: "cboxTrailer",
                                        textKey: "LABEL",
                                        valueKey: "ID",
                                        autoSelectFirstMatch: true,
                                        virtualization: true,
                                        dropDownOpening: function (evt, ui) {
                                            $("#cboxTrailer").igCombo("option", "dataSource", GLOBAL_TRAILER_OPTIONS);
                                            $("#cboxTrailer").igCombo("dataBind");
                                        },
                                        selectionChanged: function (evt, ui) {
                                            if (ui.items.length > 0) {

                                                var MSID = ui.items[0].data.ID
                                                if (MSID) {
                                                    PageMethods.getPODetailProductsFromMSID(MSID, onSuccess_getPODetailProductsFromMSID, onFail_getPODetailProductsFromMSID);

                                                    var item = $("#cboxPO").igCombo("itemsFromValue", MSID);
                                                    if (!checkNullOrUndefined(item)) {
                                                        $("#cboxPO").igCombo("value", MSID);
                                                        $("#cboxPO").igCombo("setFocus");
                                                        $("#cboxTrailer").igCombo("setFocus");
                                                    }
                                                    else {
                                                        $("#cboxPO").igCombo("deselectAll");
                                                        $("#cboxProduct").igCombo("deselectAll");

                                                    }
                                                }
                                            }
                                        }
                                    },
                                },

                                {
                                    columnKey: "PRODUCT",
                                    editorType: "combo",
                                    required: true,
                                    editorOptions: {
                                        mode: "editable",
                                        enableClearButton: false,
                                        dataSource: [],
                                        id: "cboxProduct",
                                        itemTemplate: "<span title=\"${LABEL}\">${LABEL}</span>",
                                        textKey: "LABEL",
                                        valueKey: "ID",
                                        autoSelectFirstMatch: true,
                                        selectionChanging: function (evt, ui) {
                                            if (ui.items.length > 0) {

                                                var PRODID = ui.items[0].data.ID
                                                if (PRODID) {
                                                }
                                            }
                                        }
                                    },
                                    },
                                { columnKey: "RESAMPLE", readOnly: true },
                                { columnKey: "FILEUPLOAD", readOnly: true },
                                { columnKey: "TRESULT" },
                                { columnKey: "STAKENTIME", readOnly: true },
                                { columnKey: "SSENTTIME", readOnly: true },
                                { columnKey: "SRECVTIME", readOnly: true },
                                { columnKey: "COMMENTS", editorType: "text" },
                        {
                            columnKey: "GRAVITY",
                            editorType: "numeric",
                            editorOptions: {
                                minValue: 0,
                                maxDecimals: 4,
                                minDecimals: 4
                            }
                        }

                            ]
                        },
                 ]
             })<%--end $("#gridSamples").igGrid--%>




             $("#ApproveRejectGridSamples").igGrid({
                 dataSource: GLOBAL_APPROVEREJECT_SAMPLEGRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 //autofitLastColumn: true,
                 primaryKey: "SAMPLEID",
                 columns: [
                    {
                        headerText: "Resample", key: "RESAMPLE", dataType: "string", width: "120px",
                        template: "{{if(!checkNullOrUndefined(${SRECVTIME}))}}<div class ='ColumnContentExtend'><input id='btnApproveRejectResample_${SAMPLEID}' type='button' value='Resample' onclick='GLOBAL_ISDIALOG_OPEN = true; CreateRequestForReSample(${SAMPLEID}, ${MSID}, \"${TRAILER}\", \"${PRODUCT}\", \"${PRODUCTDETAILS}\", \"${SAMPLEID}\", \"${PODETAILID}\" );' class='ColumnContentExtend'></div> " +
                            "{{else}}<div></div>{{/if}}"
                    },
                        {
                            headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "65px"
                        },
                        { headerText: "Is open in CMS", key: "isOpenInCMS", dataType: "string", width: "0px" },
                    { headerText: "MSID", key: "MSID", dataType: "number", width: "0px" },
                    { headerText: "", key: "PODETAILID", dataType: "number", width: "0px", hidden: true },
                    { headerText: "", key: "FILEID", dataType: "number", width: "0px", hidden: true },
                    { headerText: "", key: "FILEPATH", dataType: "string", width: "0px", hidden: true },
                    { headerText: "", key: "FUPLOAD", dataType: "string", width: "0px", hidden: true },
                    { headerText: "", key: "FILENAME", dataType: "string", width: "0px", hidden: true },
                    { headerText: "", key: "SAMPLEID", dataType: "number", width: "0px", hidden: true },
                    { headerText: "Sample ID", key: "SAMPLEIDTEXT", dataType: "number", width: "0px" },
                    { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                    { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
                    { headerText: "Part Number", key: "PRODUCT", dataType: "string", width: "150px" },
                    { headerText: "Product", key: "PRODUCTDETAILS", dataType: "string", width: "150px" },
                    {
                        headerText: "Sample Taken from Truck", key: "STAKENTIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "110px",
                        template: "<div class ='ColumnContentExtend'>${STAKENTIME}</div>"
                    },
                    {
                        headerText: "Sample Dropped at Lab", key: "SSENTTIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "110px",
                        template: "<div class ='ColumnContentExtend'>${SSENTTIME}</div>"

                    },
                    {
                        headerText: "Sample Received by Lab", key: "SRECVTIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "110px",
                        template: "<div class ='ColumnContentExtend'>${SRECVTIME}</div>"

                    },
                    { headerText: "Lotus Sample ID", key: "TESTID", dataType: "string", width: "60px", },
                    { headerText: "Specific Gravity", key: "GRAVITY", dataType: "number", width: "75px", formatter: formatGravity },
                    {
                        headerText: "Approve / Reject", key: "TRESULT", dataType: "number", width: "120px",
                        template: "{{if (${TRESULT})}}<div>APPROVED</div>" +
                        "{{else}}<div>REJECTED</div>{{/if}}"
                    },
                    {
                        headerText: "COFA Details", key: "COFADetails", dataType: "string", width: "100px",
                        template: "{{if (!checkNullOrUndefined(${SRECVTIME}))}}<div class ='ColumnContentExtend'><input id='btnApproveRejectCOFADetails_${SAMPLEID}' type='button' value='COFA Details' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_COFAdetails(${SAMPLEID},\"RejAprv\");' class='ColumnContentExtend'></div>" +
                            "{{else}} <div></div> {{/if}}"
                    },
                    { headerText: "Lab Comments (max. 250)", key: "COMMENTS", dataType: "string", width: "225px" },
                    {
                        headerText: "COFA", key: "FILEUPLOAD", dataType: "string", width: "0px", //<div style='background-color:lightcoral; width: 100%;'>
                        template: "{{if (checkNullOrUndefined(${BYPASSER}) === true  && checkNullOrUndefined(${FILENAME}) === true)}}<div class ='ColumnContentExtend'><input id='btnUpCOFA' type='button' value='Upload COFA' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_addCOFA(${SAMPLEID});' class='ColumnContentExtend'></div>" +
                        "{{elseif (checkNullOrUndefined(${BYPASSER}) === true  && !checkNullOrUndefined(${FILENAME})) === true}} <div data-fileID='${FILEID}' style='text-align: center'><a id='alinkCOFA' href='${FUPLOAD}'>${FILENAME}</a></div>{{/if}}"
                    },
                    {
                        headerText: "Bypass COFA", key: "BYPASSER", dataType: "string", width: "0px",
                        template: "{{if (checkNullOrUndefined(${BYPASSER}) === true  && checkNullOrUndefined(${FILENAME})) === true && (!checkNullOrUndefined(${SRECVTIME}))}}<div class ='ColumnContentExtend'><input id='btnBypassCOFA' type='button' value='Bypass COFA' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_COFAdetails(${SAMPLEID},\"RejAprv\");' class='ColumnContentExtend'></div>" +
                            "{{elseif (!checkNullOrUndefined(${BYPASSER}))}} Bypass approved by: ${BYPASSER} " +
                            "{{else}} <div></div> {{/if}}"
                    },
                    { headerText: "Bypass Comment (max. 250)", key: "BYPASSCOMMENT", dataType: "string", width: "0px" }
                 ],
                 //autofitLastColumn: true,
                 features: [
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                         columnSettings: [
                                        { columnKey: 'STAKENTIME', condition: 'on' },
                                        { columnKey: 'SSENTTIME', condition: 'on' },
                                        { columnKey: 'SRECVTIME', condition: 'on' },
                                        { columnKey: 'REJECTED', allowFiltering: false },
                                        { columnKey: 'TRESULT', allowFiltering: false },
                                        { columnKey: 'FILEUPLOAD', allowFiltering: false },
                                        { columnKey: 'BYPASSER', allowFiltering: false },
                         ],
                         dataFiltering: function (evt, ui) {

                             var nExpressions = [];
                             for (i = 0; i < ui.newExpressions.length; i++) {
                                 var newcond = ui.newExpressions[i].cond;
                                 var newExpr = ui.newExpressions[i].expr;
                                 var newFieldName = ui.newExpressions[i].fieldName;
                                 if (!checkNullOrUndefined(newExpr)) {
                                     if (newFieldName.contains("STAKENTIME") || newFieldName.contains("SSENTTIME") || newFieldName.contains("SRECVTIME")) {
                                         ui.newExpressions[i].preciseDateFormat = null;
                                     }

                                     nExpressions.push(ui.newExpressions[i]);
                                 }

                             }
                             $("#gridSamples").igGridFiltering("filter", nExpressions);
                             return false;
                         },
                     },
                        {
                            name: "Updating",
                            enableAddRow: false,
                            enableDeleteRow: false, <%-- // use clickable image since this only shows on row hover --%>
                            rowEditDialogContainment: "owner",
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            columnSettings: [
                            { columnKey: "COFADetails", readOnly: true },
                                { columnKey: "REJECTED", readOnly: true },
                                { columnKey: "PRODUCTDETAILS", readOnly: true },
                                { columnKey: "isOpenInCMS", readOnly: true },
                                { columnKey: "REJECT", readOnly: true },
                                { columnKey: "MSID", readOnly: true },
                                { columnKey: "PODETAILID", readOnly: true },
                                { columnKey: "FILEID", readOnly: true },
                                { columnKey: "FILEPATH", readOnly: true },
                                { columnKey: "SAMPLEID", readOnly: true },
                                { columnKey: "SAMPLEIDTEXT", readOnly: true },
                                { columnKey: "BYPASSER", readOnly: true },
                                { columnKey: "PO", readOnly: true },
                                { columnKey: "TRAILER", readOnly: true },
                                { columnKey: "PRODUCT", readOnly: true },
                                { columnKey: "RESAMPLE", readOnly: true },
                                { columnKey: "FILEUPLOAD", readOnly: true },
                                { columnKey: "TRESULT", readOnly: true },
                                { columnKey: "STAKENTIME", readOnly: true },
                                { columnKey: "SSENTTIME", readOnly: true },
                                { columnKey: "SRECVTIME", readOnly: true },
                                { columnKey: "COMMENTS", readOnly: true },
                                { columnKey: "TESTID", readOnly: true },
                                { columnKey: "BYPASSCOMMENT", readOnly: true },
                                { columnKey: "GRAVITY", readOnly: true }

                            ]
                        },
                 ]
             })<%--end $("#gridSamples").igGrid--%>


             <%--filtering from when coming from COFA page on button click --%>
             var sampleID = sessionStorage.getItem("sampleID");
             if (checkNullOrUndefined(sampleID) == false) {
                 $("#gridSamples").igGridFiltering("filter", ([{
                     fieldName: "SAMPLEID",
                     expr: sampleID.toString(),
                     cond: "equals"
                 }]), true);
                 sessionStorage.setItem('sampleID', "");<%--reset filter --%>
             }


             $(document).delegate("#gridSamples", "iggridcellclick", function (evt, ui) {

                 if (ui.colKey === 'STAKENTIME' || ui.colKey === 'SSENTTIME' || ui.colKey === 'SRECVTIME' || ui.colKey === 'TRESULT') {
                     $("#gridSamples").data("data-disabledColsClick", true);
                 }
                 else {
                     $("#gridSamples").data("data-disabledColsClick", false);
                 }

             });



             $(document).delegate("#gridSamples", "iggridcellclick", function (evt, ui) {

                 if (ui.colKey === 'STAKENTIME' || ui.colKey === 'SSENTTIME' || ui.colKey === 'SRECVTIME' || ui.colKey === 'TRESULT' || ui.colKey === 'RESAMPLE' || ui.colKey === 'COFADetails') {
                     $("#gridSamples").data("data-disabledColsClick", true);
                     $("#gridSamples").data("data-COFACOMMENTClick", false);
                 }
                 else if (ui.colKey === 'BYPASSCOMMENT') {
                     $("#gridSamples").data("data-COFACOMMENTClick", true);
                     $("#gridSamples").data("data-disabledColsClick", false);
                 }
                 else if (ui.colKey === 'COMMENTS') {
                     $("#gridSamples").data("data-COMMENTClick", true);
                 }
                 else {
                     $("#gridSamples").data("data-disabledColsClick", false);
                     $("#gridSamples").data("data-COFACOMMENTClick", false);
                 }

             });       


             //set defaults
             $("#cboxTruckList").igCombo("value", -1);

         }; <%--function initGrid() {--%>

        function initMobileGrid() {
            $("#gridSamples").igGrid({
                dataSource: GLOBAL_SAMPLEGRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                primaryKey: "SAMPLEID",
                columns: [
                       {
                           headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED} == true)}}" +
                                           "<div class ='needsTruckMove'>Rejected</div>{{else}}<div> </div>{{/if}}", width: "0%", hidden: true
                       },
                        { headerText: "Is open in CMS", key: "isOpenInCMS", width: "0%", hidden: true },
                   { headerText: "MSID", key: "MSID", dataType: "number", width: "0%", hidden: true },
                   { headerText: "", key: "PODETAILID", dataType: "number", width: "0%", hidden: true },
                   { headerText: "", key: "FILEID", dataType: "number", width: "0%", hidden: true },
                   { headerText: "", key: "FILEPATH", dataType: "string", width: "0%", hidden: true },
                   { headerText: "", key: "FUPLOAD", dataType: "string", width: "0%", hidden: true },
                   { headerText: "", key: "FILENAME", dataType: "string", width: "0%", hidden: true },
                   { headerText: "", key: "SAMPLEID", dataType: "number", width: "0%", hidden: true },
                   { headerText: "Sample ID", key: "SAMPLEIDTEXT", dataType: "number", width: "0%", hidden: true },
                   { headerText: "PO", key: "PO", dataType: "number", width: "25%" },
                   { headerText: "Trailer#", key: "TRAILER", dataType: "string", width: "25%" },
                   { headerText: "Part Number", key: "PRODUCT", dataType: "string", width: "25%" },
                       { headerText: "Product", key: "PRODUCTDETAILS", dataType: "string", width: "25%" },
                   { headerText: "COFA", key: "FILEUPLOAD", dataType: "string", width: "0%", hidden: true },
                   { headerText: "Sample Taken from Truck", key: "STAKENTIME", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                   { headerText: "Sample Dropped at Lab", key: "SSENTTIME", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                   { headerText: "Sample Received by Lab", key: "SRECVTIME", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                   { headerText: "Approve/ Reject", key: "TRESULT", dataType: "number", width: "0%", hidden: true },
                   { headerText: "Comments", key: "COMMENTS", dataType: "string", width: "0%", hidden: true },

                ],
                features: [
                    {
                        name : 'Paging',
                        type: "local",
                        pageSize : 25
                    },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                         //columnSettings: [
                         //               { columnKey: 'STAKENTIME', condition: "after" },
                         //               { columnKey: 'SSENTTIME', condition: 'on' },
                         //               { columnKey: 'SRECVTIME', condition: 'on' },
                         //               { columnKey: 'REJECTED', allowFiltering: false },
                         //               { columnKey: 'TRESULT', allowFiltering: false },
                         //               { columnKey: 'FILEUPLOAD', allowFiltering: false },
                         //               { columnKey: 'BYPASSER', allowFiltering: false },
                         //],
                         dataFiltering: function (evt, ui) {

                             var nExpressions = [];
                             for (i = 0; i < ui.newExpressions.length; i++) {
                                 var newcond = ui.newExpressions[i].cond;
                                 var newExpr = ui.newExpressions[i].expr;
                                 var newFieldName = ui.newExpressions[i].fieldName;
                                 if (!checkNullOrUndefined(newExpr)) {
                                     if (newFieldName.contains("STAKENTIME") || newFieldName.contains("SSENTTIME") || newFieldName.contains("SRECVTIME")) {
                                         ui.newExpressions[i].preciseDateFormat = null;
                                     }

                                     nExpressions.push(ui.newExpressions[i]);
                                 }

                             }
                             $("#gridSamples").igGridFiltering("filter", nExpressions);
                             return false;
                         },
                     },
                      {
                          name: 'Sorting'
                      },
                       {
                           name: "Updating",
                           editMode: "row",
                           enableAddRow: true,
                           enableDeleteRow: true, <%-- // use clickable image since this only shows on row hover --%>
                            rowEditDialogContainment: "owner",
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            editRowStarting: function (evt, ui) {
                                if (!ui.rowAdding) {
                                    tapFunc();
                                    // hide combo boxes used in adding new row
                                    $("#editDialog").data("isAdding", false);
                                    $("#cboxPOEditDialog").hide();
                                    $("#cboxTrailerNumberEditDialog").hide();
                                    $("#cboxProductEditDialog").hide();
                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                    var trailerDialog = "";
                                    $("#POEditDialog").html(row.PO);
                                    $("#sampleIDEditDialog").html(row.SAMPLEID);
                                    if (checkNullOrUndefined(row.TRAILER) == true) { trailerDialog = ""; }
                                    else { trailerDialog = row.TRAILER }
                                    $("#trailerEditDialog").html(trailerDialog);
                                    $("#productEditDialog").html(row.PRODUCT);
                                    $("#commentEditDialog").text(row.COMMENTS);
                                    if (row.REJECT) {
                                        $("#RejectEditDialog").html("Rejected");
                                    }
                                    else {
                                        $("#RejectEditDialog").html(" ");
                                    }

                                    $("#editDialog").data("data-SampleID", row.SAMPLEID);
                                    if (row.STAKENTIME == null && row.SSENTTIME == null && row.SRECTIME == null) {
                                        $("#sTakenTimeEditDialog").html(" ");
                                        $("#btnSTakenEditDialog").show();
                                        $("#takenUndoEditDialog").hide();

                                        $("#sSentTimeEditDialog").html(" ");
                                        $("#btnSSentEditDialog").hide();
                                        $("#sentUndoEditDialog").hide();
                                        $("#commentEditDialog").text(row.COMMENTS);
                                        $("#editDialog").igDialog("open");
                                        return false;

                                    }
                                    else if (row.STAKENTIME != null && row.SSENTTIME == null && row.SRECTIME == null) {
                                        $("#sTakenTimeEditDialog").html(formatDate(row.STAKENTIME));
                                        $("#btnSTakenEditDialog").hide();
                                        $("#takenUndoEditDialog").show();

                                        $("#sSentTimeEditDialog").html(" ");
                                        $("#btnSSentEditDialog").show();
                                        $("#sentUndoEditDialog").hide();
                                        $("#commentEditDialog").text(row.COMMENTS);
                                        $("#editDialog").igDialog("open");
                                        return false;
                                    }
                                    else if (row.STAKENTIME != null && row.SSENTTIME != null && row.SRECTIME == null) {
                                        $("#sTakenTimeEditDialog").html(formatDate(row.STAKENTIME));
                                        $("#btnSTakenEditDialog").hide();
                                        $("#takenUndoEditDialog").hide();

                                        $("#sSentTimeEditDialog").html(formatDate(row.SSENTTIME));
                                        $("#btnSSentEditDialog").hide();
                                        $("#sentUndoEditDialog").show();
                                        $("#commentEditDialog").text(row.COMMENTS);
                                        $("#editDialog").igDialog("open");
                                        return false;
                                    }
                                    else if (row.STAKENTIME != null && row.SSENTTIME != null && row.SRECTIME != null) {
                                        $("#sTakenTimeEditDialog").html(formatDate(row.STAKENTIME));
                                        $("#btnSTakenEditDialog").hide();
                                        $("#takenUndoEditDialog").hide();

                                        $("#sSentTimeEditDialog").html(formatDate(row.SSENTTIME));
                                        $("#btnSSentEditDialog").hide();
                                        $("#sentUndoEditDialog").hide();
                                        $("#commentEditDialog").text(row.COMMENTS);
                                        $("#editDialog").igDialog("open");
                                    }
                                    <%--PLEASE NOTE: if this dialog box is not opening, it may be because there is corrupt data--%>
                                    return false;
                                }
                            },
                           rowAdding: function (evt, ui) {
                                var origEvent = evt.originalEvent;
                                if (typeof origEvent == "undefined") {
                                    ui.keepEditing = true;
                                    return false;
                                }
                                if (!(origEvent.type === "click" && ui.update === true)) { <%-- cancel event if when a different row or cancel is clicked; only add row when done button is clicked--%>
                                    return false;
                                }
                                else {
                                    var rMSID = ui.values.PO;
                                    var rPODetailsID = ui.values.PRODUCT;
                                    var rComments = ui.values.COMMENTS;

                                    PageMethods.createSample(rMSID, rPODetailsID, null, onSuccess_createSample, onFail_createSample, rMSID);
                                    return false; <%--do to prevent infragistics javascript errors due to conditional template--%>
                                 }
                            },
                            rowDeleting: function (evt, ui) {
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);

                                var r = confirm("Continue deleting sample data for " + row.PO + " " + row.PRODUCT.trim() + "? Deletion cannot be undone.");
                                if (r === true) {
                                    var rSampleID = row.SAMPLEID;
                                    var rMSID = row.MSID;
                                    PageMethods.deleteSample(rSampleID, rMSID, onSuccess_deleteSample, onFail_deleteSample, rMSID);
                                }
                                else {
                                    return false;
                                }
                            },
                            columnSettings: [
                                { columnKey: "PRODUCTDETAILS", readOnly: true },
                                       { columnKey: "isOpenInCMS", readOnly: true },
                                       { columnKey: "REJECT", readOnly: true },
                                       { columnKey: "MSID", readOnly: true },
                                       { columnKey: "PODETAILID", readOnly: true },
                                       { columnKey: "FILEID", readOnly: true },
                                       { columnKey: "FILEPATH", readOnly: true },
                                       { columnKey: "SAMPLEID", readOnly: true },
                                       { columnKey: "SAMPLEIDTEXT", readOnly: true },
                                       {
                                           columnKey: "PO",
                                           editorType: "combo",
                                           required: true,
                                           editorOptions: {
                                               mode: "editable",
                                               enableClearButton: false,
                                               dataSource: GLOBAL_PO_OPTIONS,
                                               itemTemplate: "<span title=\"${LABEL}\">${LABEL}</span>",
                                               id: "cboxPO",
                                               textKey: "LABEL",
                                               valueKey: "ID",
                                               autoSelectFirstMatch: true,
                                               virtualization: true,
                                               dropDownOpening: function (evt, ui) {
                                                   $("#cboxPO").igCombo("option", "dataSource", GLOBAL_PO_OPTIONS);
                                                   $("#cboxPO").igCombo("dataBind");
                                                   var currentlySelectedPO = $("#cboxTruckList").igCombo("value");
                                                   if (currentlySelectedPO != -1) {
                                                       $("#cboxPO").igCombo("value", currentlySelectedPO);
                                                   }
                                               },
                                               selectionChanged: function (evt, ui) {
                                                   if (ui.items.length > 0) {
                                                       var MSID = ui.items[0].data.ID
                                                       if (MSID) {
                                                           PageMethods.getPODetailProductsFromMSID(MSID, onSuccess_getPODetailProductsFromMSID, onFail_getPODetailProductsFromMSID);
                                                           var item = $("#cboxTrailer").igCombo("itemsFromValue", MSID);
                                                           if (!checkNullOrUndefined(item)) {
                                                               $("#cboxTrailer").igCombo("value", MSID);
                                                           }
                                                           else {
                                                               $("#cboxTrailer").igCombo("deselectAll");
                                                               $("#cboxProduct").igCombo("deselectAll");
                                                           }

                                                       }
                                                   }
                                               }
                                           },
                                       },
                                       {
                                           columnKey: "TRAILER",
                                           editorType: "combo",
                                           required: false,
                                           editorOptions: {
                                               mode: "editable",
                                               enableClearButton: false,
                                               dataSource: GLOBAL_TRAILER_OPTIONS,
                                               itemTemplate: "<span title=\"${LABEL}\">${LABEL}</span>",
                                               id: "cboxTrailer",
                                               textKey: "LABEL",
                                               valueKey: "ID",
                                               autoSelectFirstMatch: true,
                                               virtualization: true,
                                               dropDownOpening: function (evt, ui) {
                                                   $("#cboxTrailer").igCombo("option", "dataSource", GLOBAL_TRAILER_OPTIONS);
                                                   $("#cboxTrailer").igCombo("dataBind");
                                               },
                                               selectionChanged: function (evt, ui) {
                                                   if (ui.items.length > 0) {
                                                       var MSID = ui.items[0].data.ID
                                                       if (MSID) {
                                                           PageMethods.getPODetailProductsFromMSID(MSID, onSuccess_getPODetailProductsFromMSID, onFail_getPODetailProductsFromMSID);
                                                           var item = $("#cboxPO").igCombo("itemsFromValue", MSID);
                                                           if (!checkNullOrUndefined(item)) {
                                                               $("#cboxPO").igCombo("value", MSID);
                                                           }
                                                           else {
                                                               $("#cboxPO").igCombo("deselectAll");
                                                               $("#cboxProduct").igCombo("deselectAll");

                                                           }
                                                       }
                                                   }
                                               }
                                           },
                                       },
                                       {
                                           columnKey: "PRODUCT",
                                           editorType: "combo",
                                           required: true,
                                           editorOptions: {
                                               mode: "editable",
                                               enableClearButton: false,
                                               dataSource: [],
                                               id: "cboxProduct",
                                               textKey: "LABEL",
                                               valueKey: "ID",
                                               autoSelectFirstMatch: true,
                                               selectionChanging: function (evt, ui) {
                                                   if (ui.items.length > 0) {
                                                       var PRODID = ui.items[0].data.ID
                                                       //if (PRODID) {
                                                       //}
                                                   }
                                               }
                                           },
                                       },
                                       { columnKey: "TRESULT" },
                                       { columnKey: "STAKENTIME", readOnly: true },
                                       { columnKey: "SSENTTIME", readOnly: true },
                                       { columnKey: "SRECVTIME", readOnly: true },
                                       { columnKey: "COMMENTS", required: false, editorType: "text" }
                            ],
                        },
                 ]
             })<%--end $("#gridSamples").igGrid--%>

             $("#cboxTruckList").igCombo("value", -1);

            

             $("#btnRejectedTrucks").hide();
        }; <%--function initMobileGrid() {--%>

        function tapFunc() {
            var field = document.createElement('input');
            field.setAttribute('type', 'text');
            document.body.appendChild(field);
            field.focus();
            field.setAttribute('style', 'display:none;');
            
        }
        function checkForRedirect() {
            
            var url_string = window.location.href;
            var url = new URL(url_string);
            var MSIDRedirect = url.searchParams.get("MSID");
            if (MSIDRedirect) {

                showProgress();
                
                $("#cboxTruckList").igCombo("value", MSIDRedirect);
                $("#gridSamples").igGridFiltering("filter", ([{
                                fieldName: "MSID",
                                expr: MSIDRedirect,
                                cond: "equals"
                            }]), true);
                
                var gridDataAfterFilter = $("#gridSamples").igGrid().data("igGrid").dataSource.dataView();
                
                $("#gridSamples").data("data-SampleID", gridDataAfterFilter["SAMPLEID"]);

                $("#gridSamples").data("data-MSID", MSIDRedirect);
                var afterLength = gridDataAfterFilter.length;
                if (0 === afterLength) {
                    hideProgress();
                    alert("No sample found. Please select the truck in the dropdown and create a sample.");
                }
                showProgress();
                $("#cboxTruckList").data("data-allIsSelected", false);
                $("#locationOptionsWrapper").show();
                $("#locationLabelWrapper").show();
                PageMethods.GetLocationOptions(MSIDRedirect, onSuccess_GetLocationOptions, onFail_GetLocationOptions, MSIDRedirect);
            }

        }
         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls  
         -------------------------------------------------------%>
        $(function () {
            showProgress();
            $(".arrowGridScrollButtons").show();
            $("#btnViewTruck").hide();
            GLOBAL_IS_MOBILE_VIEWING = isOnMobile();
            if (GLOBAL_IS_MOBILE_VIEWING == false) {
                $("#logButton").click(function () {
                    var logDisplay = $('#logTableWrapper').css('display');
                    truckLog_MiniMaxAndRemember(logDisplay);
                });
            }


            $(document).on("focus", "input", function (e) {
                if (GLOBAL_IS_MOBILE_VIEWING == true) {
                    if (e.currentTarget.className == 'ui-igcombo-field ui-corner-all') {
                        tapFunc();
                    }
                }
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
                        if (checkNullOrUndefined(ui.items[0].data.MSID) == false) {
                            $("#gridSamples").igGridFiltering("filter", ([{
                                fieldName: "MSID",
                                expr: ui.items[0].data.MSID,
                                cond: "equals"
                            }]), true);
                        }
                        else {
                            $("#lblLocation").hide();
                            $("#cboxLocations").hide();
                        }
                    }
                    else if (ui.items.length == 0) {
                        $("#tableLog").empty();
                    }
                }
            });
            //PageMethods.GetLogList(onSuccess_GetLogList, onFail_GetLogList);

           
            var windowWidth = $(window).width();
            windowWidth = windowWidth - 10;
            
            $("#editDialog").igDialog({
                width: windowWidth + 'px',
                height: "500px",
                state: "closed",
                closeButtonTitle: "X",
                stateChanging: function (evt, ui) {
                    var isAdding = $("#editDialog").data("isAdding");
                    if (ui.action === "open" && isAdding === false) {
                        $("#cboxPOEditDialog").hide();
                        $("#cboxTrailerNumberEditDialog").hide();
                        $("#cboxProductEditDialog").hide();
                    };
                }
            });
            var textAreaWidth = getWidthForTextAreaForMobilePopUp();
            $("#commentEditDialog").css({ "width": textAreaWidth });

            $("#COFAdetailsDialog").igDialog({
                minWidth: "300px",
                minHeight: "300px",
                maxHeight: "75%",
                state: "closed",
                resizable: false,
                modal: true,
                draggable: false,
                showCloseButton: true
            });

            var maxWidthComboDropDown = textAreaWidth;
            if (GLOBAL_IS_MOBILE_VIEWING == false) {
                maxWidthComboDropDown = "350px";
            }
            

            $("#cboxTruckList").igCombo({
                dataSource: null,
                textKey: "PO",
                valueKey: "MSID",
                width: "200px",
                enableClearButton: false,
                //mode: "dropdown",
                dropDownWidth: maxWidthComboDropDown,
                highlightMatchesMode: "contains",
                filteringCondition: "contains",
                autoSelectFirstMatch: false,
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        //$(".dvGridFilterButtons").hide();
                        var MSID = ui.items[0].data.MSID;
                        $("#dockSpotOptionsWrapper").hide();

                        if (MSID == -1) {
                            $("#cboxTruckList").data("data-allIsSelected", true);
                            PageMethods.getSampleGridData(onSuccess_getSampleGridData, onFail_getSampleGridData);
                            $("#locationOptionsWrapper").hide();
                            $("#locationLabelWrapper").hide();
                            $(".dvGridFilterButtons").show();
                        }
                        else {
                        $("#gridSamples").igGridFiltering("filter", ([{
                                fieldName: "MSID",
                                expr: MSID,
                                cond: "equals"
                            }]), true);

                            $("#cboxTruckList").data("data-allIsSelected", false);
                            //PageMethods.getSampleGridDataByMSID(MSID, onSuccess_getSampleGridDataByMSID, onFail_getSampleGridDataByMSID);
                            $("#locationOptionsWrapper").show();
                            $("#locationLabelWrapper").show();
                            PageMethods.GetLocationOptions(MSID, onSuccess_GetLocationOptions, onFail_GetLocationOptions, MSID);
                            //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
                        }
                    }
                    else {
                        $("#locationOptionsWrapper").hide();
                        $("#locationLabelWrapper").hide();
                    }
                }
            });


            $("#cboxLocations").igCombo({
                dataSource: null,
                textKey: "LOCTEXT",
                valueKey: "LOC",
                width: "200px",
                dropDownWidth: "300px",
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
            $("#locationOptionsWrapper").hide();

            $("#cboxDockSpots").igCombo({
                dataSource: null,
                textKey: "DOCKSPOT",
                valueKey: "SPOTID",
                width: "200px",
                autoComplete: true,
                enableClearButton: false,
                selectionChanging: function (evt, ui) {
                    //if (ui.items.length > 0) {


                    //}

                },
                selectionChanged: function (evt, ui) {
                }
            });
            $("#locationOptionsWrapper").hide();
            $("#dockSpotOptionsWrapper").hide();
            
            PageMethods.getListofTrucksCurrentlyInZXP(onSuccess_getListofTrucksCurrentlyInZXP, onFail_getListofTrucksCurrentlyInZXP);

        }); <%-- $(function () {  --%>

         <%--when window is resize, this will check the width of the window and set the appropriately editMode--%>
        $(window).resize(function () {
            var width = $(window).width();
            if (width <= 850) {
                $("#editDialog").dialog("option", "position", "center");
                GLOBAL_IS_MOBILE_VIEWING = true;
            }
            else {
                $("#gridSamples").igGridUpdating("option", "editMode", "row");
                GLOBAL_IS_MOBILE_VIEWING = false;
            }
        });
        
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
                    <label id="lbl_Loc">Location</label><input id="cboxLocations" /></td>
                </tr>
            <tr> 
                <td>
                    <span id="dockSpotOptionsWrapper"><label id="lbl_dockSposts">Dock Spot</label><input id="cboxDockSpots" /> </span> </td>  
                </tr>
            <tr> 
                <td>
                    <button type="button" id="btn_updateLocation" onclick='onclick_btnUpdateLocation();'>Update Location</button></td>
                <td>
                    <button type="button" id="btn_closeLocation" onclick='onclick_btncloseLocation();'>Close Location Info</button></td>
            </tr>
        </table>
    </div>
    <div class="dvGridFilterButtons">
        <button type="button" onclick='clearGridFilters(); return false;'>Show All Samples</button>
        <button type="button" onclick='onclick_ShowRejectedTrucks(); return false;' id="btnRejectedTrucks">Show Rejected Trucks</button>
    </div>

    <div id="dvGridSamples" style="display: none;">
        <table id="gridSamples" class="scrollGridClass"></table>
    </div>
    <br />
    <br />
    <h2 id="apprvRejLabel">Approved and Rejected Samples</h2>
    <div id="dvApproveRejectGridSamples">
        <table id="ApproveRejectGridSamples" class="scrollGridClass"></table>
    </div>

    <div id="editDialog">
        <table style="border: 0;">
            <tr><td><label class="mobileLbl">Rejected: </label></td><td><label class="mobileLbl" id = "RejectEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">PO: </label></td><td><label class="mobileLbl" id = "POEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Sample ID: </label></td><td><label class="mobileLbl" id = "sampleIDEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">Trailer Number: </label></td><td><label class="mobileLbl" id = "trailerEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">Product: </label></td><td><label class="mobileLbl" id = "productEditDialog"></label></td></tr>
            <tr><td></td></tr>
            <tr><td><label class="mobileLbl">Sample Taken <wbr>from Truck: </label></td><td><label class="mobileLbl" id = "sTakenTimeEditDialog"></label>
                    <input id="btnSTakenEditDialog" type="button" value='Sample Taken' onclick="onclick_dialogButtonClick('moveFwd', 'taken');"></td><td>
                    <span id="takenUndoEditDialog" class="Mi4_undoIcon" onclick="onclick_dialogButtonClick('undo','taken')"></span></td>
            </tr>

            <tr><td><label class="mobileLbl">Sample Dropped <wbr>at Lab: </label></td><td><label class="mobileLbl" id = "sSentTimeEditDialog"></label>
                    <input id="btnSSentEditDialog" type="button" value='Sample Sent' onclick="onclick_dialogButtonClick('moveFwd', 'sent');"></td><td>
                     <span id="sentUndoEditDialog" class="Mi4_undoIcon" onclick="onclick_dialogButtonClick('undo','sent')"></span></td>
            </tr>
            <tr>
                <td></td>
        </table>
        <table style="border: 0;">
            <tr><td><label class="mobileLbl">Comments:</label></td><td><textarea id="commentEditDialog" maxlength="250"></textarea></td></tr>
            <tr><td></td><td>
                    <button type="button" id="btnSave" onclick='onclick_btnSaveEditDialog(); return false;'>Save</button>
                    <button type="button" id="btnCancel" onclick='onclick_btnCancelEditDialog(); return false;'>Cancel</button></td>
            </tr>
        </table>
    </div>


    <div id="COFAdetailsDialog">
        <table style="border: 0;">
            <%--<tr>
                <td>
                    <label id="MSIDDialog">MSID: </label>
                </td>
            </tr>
            <tr>
                <td>
                    <label id="sampleIDDialog">Sample ID: </label>
                </td>
            </tr>--%>
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
                    <label id="productDialog">Product: </label>
                </td>
            </tr>

            <tr>
                <td><label id="COFAstatus"></label><div id="COFAfileDialog"><a id='alinkCOFADialog' >xXx</a></div>
                    <input id='btnUpCOFADialog' type='button' value='Upload COFA' onclick='GLOBAL_ISDIALOG_OPEN = true; onclick_addCOFA();' class='ColumnContentExtend'>
                </td>
            </tr>


            <tr>
                <td></td>
            </tr>
            <tr>
                <td>
                    <label>Bypass Comments:</label><textarea id="commentDialog" maxlength="250"></textarea></td>
            </tr>
            <tr  id="trLabAdminUserName">
                <td>
                    <label id="lblLabAdminUN">Lab Admin Username: </label>
                    <input type="text" id="txtLabAdminUN"></td>
            </tr>
            <tr id="trLabAdminUserPass">
                <td>
                    <label id="lblLabAdminPassword">Lab Admin Password: </label>
                    <input type="password" id="txtLabAdminPassword"></td>
            </tr>
            <tr>
                <td>
                    <button type="button" id="bypassBtnSave" onclick='onclick_btnApproveBypassDialog(); return false;'>Approve Bypass</button>
                    <button type="button" id="bypassBtnClose" onclick='onclick_btnCancelBypassDialog(); return false;'>Close</button>
                </td>
            </tr>
        </table>
    </div>

</asp:Content>
