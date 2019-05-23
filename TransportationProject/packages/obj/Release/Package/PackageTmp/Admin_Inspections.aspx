<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_Inspections.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_Inspections1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Inspections</h2>
    <h3>View, add, update, and delete inspections.</h3>
        <br />
        <br />
    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_CELLULARPROVIDER_OPTIONS = [];
        var GLOBAL_GRID_DATA = [];
        var GLOBAL_INSPECTION_LIST = [];
        var GLOBAL_INSPECTIONID = 0;
        var GLOBAL_GRID_EXIST = false;
        var GLOBAL_LOADTYPE;
        var GLOBAL_INSPECTIONTYPE = null;
        var GLOBAL_HAS_BEEN_USED = false; <%--var to get return t/f value to see if this inspection has been used --%>
        var GLOBAL_ALLOW_TEST_CHANGES = false; <%--flag for test changes--%>
        var GLOBAL_ALLOW_INSPECTION_CHANGES = false; <%--flag for inspection changes--%>
        var GLOBAL_TESTID = 0; <%--for dialog box: when its confirm that changes can be made --%>
        var GLOBAL_NEWTESTTEXT = "";
        var GLOBAL_NEWSORTORDER = 0;
        var GLOBAL_INSPECTIONTYPES = []; <%--for combo box, for editing --%>
        var GLOBAL_LOADTYPES = []; <%--for combo box, for editing --%>
        var GLOBAL_INSPECTIONNAME = null; <%--for dialog box before delete--%>
        var GLOBAL_INSPECTION_ORDER_GRID = [];
        var FILTERTEXTID = "";
        var FILTERTEXTNAME = "";
        var FILTERTEXT = "";

        <%-------------------------------------------------------
        Functions
        ---------------------------------------------------------%>

        function setIframe(newSrc) {
            if (newSrc)
                $("#iframeContent").attr('src', newSrc)
        }
        function initSortable() {
            $("#grid tbody").sortable({
                containment: "parent",
                start: function (evt, ui) {
                    var children = ui.item.children();
                    $("#grid_headers thead th").each(function (ix, el) {
                        // set the width of each td to its header width
                        $(children[ix]).width($(el).width());
                    });
                },
                stop: function (evt, ui) {
                    var newSortOrder = 1;
                    $('#grid > tbody  > tr').each(function () {
                        var TestID = this.dataset.id;
                        var InspectionHeaderID = $("#cboxInspectionList").igCombo("value");

                        PageMethods.setNewSortOrder(InspectionHeaderID, TestID, newSortOrder, onSuccess_setNewSortOrder, onFail_setNewSortOrder, newSortOrder);
                        newSortOrder++;
                    });

                }
            });
            $("#grid tbody").disableSelection();
        }

        <%-------------------------------------------------------
        Pagemethods Handlers
        //-------------------------------------------------------%>

        function onSuccess_getInspectionList(value, currentlySelectedInspectionID, methodName) {
            GLOBAL_INSPECTION_LIST = [];
            for (i = 0; i < value.length; i++) {
                GLOBAL_INSPECTION_LIST[i] = { "ID": value[i][0], "LABEL": value[i][1], "LOADTYPE": value[i][2], "INSPECTIONTYPE": value[i][3], "is2Runner": value[i][4], "SORTORDER": value[i][5], "ORDERARROWS": ""};
            }

            <%--has newly added inspection that has no test. This is due to inspections not being added to db until they have atleast one test--%>
            if (currentlySelectedInspectionID && typeof (currentlySelectedInspectionID) === 'number') {
                var currentInspectionIndex;
                $("#cboxInspectionList").igCombo("option", "dataSource", GLOBAL_INSPECTION_LIST);
                $("#cboxInspectionList").igCombo("dataBind");
                $("#cboxInspectionList").igCombo("value", currentlySelectedInspectionID);

                //search for index and set current vals
                currentInspectionIndex = searchInspectionList(currentlySelectedInspectionID);
                var index = searchInspectionList(currentlySelectedInspectionID);
                var loadType = GLOBAL_INSPECTION_LIST[index].LOADTYPE;
                var inspectionType = GLOBAL_INSPECTION_LIST[index].INSPECTIONTYPE;
                var is2Runner = GLOBAL_INSPECTION_LIST[index].is2Runner;

                $("#grid").data("data-CurrentInspectionType", GLOBAL_INSPECTION_LIST[currentInspectionIndex].INSPECTIONTYPE);
                $("#grid").data("data-is2Runner", GLOBAL_INSPECTION_LIST[currentInspectionIndex].is2Runner);
                //if (GLOBAL_INSPECTION_LIST[currentInspectionIndex].is2Runner == true) {
                //    $("#grid").data("data-is2Runner", "Yes");
                //}
                //else {
                //    $("#grid").data("data-is2Runner", "No");
                //}

                $("#grid").data("data-CurrentLoadType", GLOBAL_INSPECTION_LIST[currentInspectionIndex].LOADTYPE);
                GLOBAL_INSPECTIONID = currentlySelectedInspectionID;
                $("#btn_addNewInspection").removeAttr('disabled');
                PageMethods.getAdminInspectGridData(currentlySelectedInspectionID, onSuccess_getAdminInspectGridData, onFail_getAdminInspectGridData);

            }
            else if (currentlySelectedInspectionID && typeof (currentlySelectedInspectionID) != 'number') {
                GLOBAL_INSPECTION_LIST.unshift({ "ID": -1, "LABEL": currentlySelectedInspectionID });
                GLOBAL_GRID_DATA.length = 0
                $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA);
                $("#grid").igGrid("dataBind");
                $("#cboxInspectionList").igCombo("option", "dataSource", GLOBAL_INSPECTION_LIST);
                $("#cboxInspectionList").igCombo("dataBind");
                $("#cboxInspectionList").igCombo("value", -1);
                $("#btn_deleteHeaderDetails").removeAttr('disabled');
                $("#btn_cancelNewInspection").removeAttr('disabled');
                $("#gridWrapper").show();
            }
                <%--has no newly added inspections waiting for test --%>
            else {
                $("#cboxInspectionList").igCombo("option", "dataSource", GLOBAL_INSPECTION_LIST);
                $("#cboxInspectionList").igCombo("dataBind");
                PageMethods.getLoadTypes(onSuccess_getLoadTypes, onFail_getLoadTypes);
            }
    }



    function onFail_getInspectionList(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_getInspectionList");
    }

    function onSuccess_getLoadTypes(value, ctx, methodName) {
        var i;
        var indexForDefault = 0;
        GLOBAL_LOADTYPES = [];
        for (i = 0; i < value.length; i++) {
            GLOBAL_LOADTYPES.push({ "LOADTYPE": value[i][0], "LOADTYPETEXT": value[i][1] });
        }

        $("#cboxLoadTypes").igCombo("option", "dataSource", GLOBAL_LOADTYPES);
        $("#cboxLoadTypes").igCombo("dataBind");

        PageMethods.getInspectionTypes(onSuccess_getInspectionTypes, onFail_getInspectionTypes);

    }
    function onFail_getLoadTypes(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_getLoadTypes");
    }

    function onSuccess_getInspectionHeaderDetails(value, ctx, methodName) {
        var iHDList = [];
        for (i = 0; i < value.length; i++) {
            iHDList[i] = { "ID": value[i][0], "LABEL": value[i][1] };
        }
    }
    function onFail_getInspectionHeaderDetails(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_getInspectionHeaderDetails");
    }

    function onSuccess_getInspectionTypes(value, ctx, methodName) {
        GLOBAL_INSPECTIONTYPES = [];
        for (i = 0; i < value.length; i++) {
            GLOBAL_INSPECTIONTYPES[i] = { "ID": value[i][0], "INSPECTIONLABEL": value[i][1] };
        }
        $("#cboxInspectionTypes").igCombo("option", "dataSource", GLOBAL_INSPECTIONTYPES);
        $("#cboxInspectionTypes").igCombo("dataBind");

        initGrid();
    }
    function onFail_getInspectionTypes(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_getInspectionTypes");
    }

    function onSuccess_updateInspection(value, ctx, methodName) {

    }
    function onFail_updateInspection(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_updateInspection");
    }

    function onSuccess_checkInspectionHeaderName(value, ctx, methodName) {
        var isNewInspection = $("#dwEditInspectionHeader").data("data-isNewInspection");
        var newInspectionName = $("#txtBoxInspectionName").val();

            <%--For new inspections: --%>
            if (isNewInspection == true) {
                if (value.length > 0) { <%--if inspection name exist, alert user and change border of text box to red --%>
                    alert("Another inspection is already named " + ctx + ". Please rename the new inspection.");
                    $("#txtBoxInspectionName").css({ "border-color": "red", "border-width": "3px", "border-style": "solid" });
                    $("#dwEditInspectionHeader").data("data-inValidName", true);
                }
                else {<%--if inspection name does not exist, remove border --%>
                    $("#txtBoxInspectionName").css({ "border-color": "", "border-width": "", "border-style": "" });
                    <%--then check to see if inspection type and load type is populated  --%>
                    var currentInspectionType = $("#cboxInspectionTypes").val();
                    var currentLoadType = $("#cboxLoadTypes").val();
                    $("#dwEditInspectionHeader").data("data-inValidName", false);
                }
            }
        }
        function onFail_checkInspectionHeaderName(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_checkInspectionHeaderName");
        }


        function onSuccess_checkIfLastTestAndDisable(value, testID, methodName) {
            if (value) {
                var inspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");
                if (value == 1) {
                    var currentInspectionName = $("#cboxInspectionList").val();
                    var inspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");

                    var c = confirm("The test you are about to delete is the last test in " + currentInspectionName + ". By deleting this test you will also delete " + currentInspectionName +
                                    ". These actions can not be undone. Would you like to continue deleting this test?");

                    if (c == true) {
                        $("#grid").igGridUpdating('deleteRow', testID);
                        $("#grid").igGrid("commit");
                        PageMethods.disableTest(testID, inspectionID, onSuccess_disableTest, onFail_disableTest, inspectionID);
                    }
                }
                if (value > 1) {

                    var c = confirm("Continue deleting test? This action can not be undone");

                    if (c == true) {
                        $("#grid").igGridUpdating('deleteRow', testID);
                        $("#grid").igGrid("commit");
                        PageMethods.disableTest(testID, inspectionID, onSuccess_disableTest, onFail_disableTest);
                    }
                }
            }
        }
        function onFail_checkIfLastTestAndDisable(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_checkIfLastTestAndDisable");
        }



        function onSuccess_disableTest(value, inspectionID, methodName) {
            if (inspectionID) {<%--the inspection ID is passed when the inspection is going to be delete--%>
                PageMethods.disableInspection(inspectionID, onSuccess_disableInspection, onFail_disableInspection);
            }
            var InspectionHeaderID = $("#cboxInspectionList").igCombo("value");
            PageMethods.getAdminInspectGridData(InspectionHeaderID, onSuccess_getAdminInspectGridData, onFail_getAdminInspectGridData);
        }
        function onFail_disableTest(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_disableTest");
        }

        function onSuccess_setNewInspectionSetNewTestAndAssociate(value, ctx, methodName) {
            if (value.length == 2) {
                $("#grid").igGridUpdating("setCellValue", ctx, 'TESTID', value[1]);
                $("#grid").igGrid("commit");
                $("#dwEditInspectionHeader").data("data-isNewInspection", false);
                $("#grid").data("data-isFirstTestOfANewInspection", false);
                $("#dwEditInspectionHeader").data("data-CurrentInspectionID", value[0]);
                $("#btn_cancelNewInspection").hide();
                PageMethods.getInspectionList(onSuccess_getInspectionList, onFail_getInspectionList, Number(value[0]));
            }
        }
        function onFail_setNewInspectionSetNewTestAndAssociate(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_setNewInspectionSetNewTestAndAssociate");
        }

        function onSuccess_setNewTestAndAssociateToInspection(newTestID, oldTestID, methodName) {
            var InspectionHeaderID = $("#cboxInspectionList").igCombo("value");
            PageMethods.getAdminInspectGridData(InspectionHeaderID, onSuccess_getAdminInspectGridData, onFail_getAdminInspectGridData);
        }
        function onFail_setNewTestAndAssociateToInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_setNewTestAndAssociateToInspection");
        }

        function onSuccess_getAdminInspectGridData(value, ctx, methodName) {
            GLOBAL_GRID_DATA.length = 0;
            var loadType;
            var inspectionType;
            $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA);
            if (value.length > 0) {
                var isDealBreaker;
                for (i = 0; i < value.length; i++) {

                    if(checkNullOrUndefined(value[i][3]) == true){
                        isDealBreaker = false;
                    }
                    else{
                        isDealBreaker = value[i][3];
                    }

                    GLOBAL_GRID_DATA[i] = {
                        "TESTID": value[i][0], "TESTTEXT": value[i][1], "SORTORDER": value[i][2], "ISDEALBREAKER": isDealBreaker
                    };
                }
            }
            <%--Checks to see if grid exist. if so bind new data, if not init grid--%>
            if (GLOBAL_GRID_EXIST === true) {
                $("#grid").igGrid("dataBind");
                $("#grid").igGrid("commit");
            }
            else {
                initGrid();
            }
            

            $("#gridWrapper").show();

        }
        function onFail_getAdminInspectGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_getAdminInspectGridData");
        }

        function onSuccess_checkIfPartOfMultiInspection(value, ctx, methodName) {
            if (value > 1) {
                $("#grid").data("data-MultiInspecTest", true);
            }
            else {
                $("#grid").data("data-MultiInspecTest", false);
            }
        }
        function onFail_checkIfPartOfMultiInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_checkIfPartOfMultiInspection");
        }

        function onSuccess_checkIfTestHasBeenUsed(value, ctx, methodName) {
            if (value == true) {
                $("#grid").data("data-hasBeenUsed", true);
            }
            else {
                $("#grid").data("data-hasBeenUsed", false);
            }

            var inspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");
            if (inspectionID > 0) {// double checks to make sure this is not a new inspection edit
                PageMethods.checkIfOpenInspection(inspectionID, onSuccess_checkIfOpenInspection, onFail_checkIfOpenInspection);
            }

        }
        function onFail_checkIfTestHasBeenUsed(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_checkIfTestHasBeenUsed");
        }

        function onSuccess_checkIfOpenInspection(value, ctx, methodName) {
            if (value > 0) {
                $("#grid").data("data-isPartOfOpenInspection", true);
                return;
            }
            else {
                $("#grid").data("data-isPartOfOpenInspection", false);
            }
        }
        function onFail_checkIfOpenInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_checkIfOpenInspection");
        }

        function onSuccess_updateTest(value, ctx, methodName) {
            $("#grid").igGrid("commit");
        }
        function onFail_updateTest(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_updateTest");
        }


        function onSuccess_updateInspectionHeader(value, currentlySelectedInspectionID, methodName) {
            PageMethods.getInspectionList(onSuccess_getInspectionList, onFail_getInspectionList, currentlySelectedInspectionID);

            $("#dwEditInspectionHeader").igDialog("close");
            //update inspection listX
            //set newly created inspection default
            //create empty grid (show)
            //reset values
        }
        function onFail_updateInspectionHeader(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_updateInspectionHeader");
        }

        function onSuccess_disableInspection(value, ctx, methodName) {
            GLOBAL_GRID_DATA = [];
            $("#grid").igGrid("dataBind");
            GLOBAL_INSPECTIONTYPE = null;
            GLOBAL_LOADTYPE = null;
            $("#btn_deleteInspection").hide();
            $("#btn_cancelNewInspection").hide();
            $("#lblInspectionType").text("");
            $("#lblLoadType").text("");
            $("#lblIs2Runner").text("");
            $("#btn_addNewInspection").removeAttr('disabled');

            PageMethods.getInspectionList(onSuccess_getInspectionList, onFail_getInspectionList);
        }
        function onFail_disableInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_disableInspection");
        }
        


        function onSuccess_preDelete_checkIfInspectionHasAlert(alertsToBeDeleted, ctx, methodName) {
            var currentInspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID"); 
            var currentInspectionName = $("#cboxInspectionList").val();

            var c = confirm("You are attempting to delete " + currentInspectionName + ". By deleting this tank you will delete the following inpection(s) as well: " + currentInspectionName + " Would you like to continue deleting request for " + tankToBeDeleted + "? Deletion cannot be undone.");
            var c = confirm("Continue deleting request for " + currentInspectionName + "? Deletion cannot be undone.");
            if (c == true) {
                PageMethods.disableInspection(currentInspectionID, onSuccess_disableInspection, onFail_disableInspection);
                return false; <%--handling deletion using own function --%>
            }
        }
        function onFail_preDelete_checkIfInspectionHasAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_preDelete_checkIfInspectionHasAlert");
        }
        <%-------------------------------------------------------
        onClick and other non page methods functions
        -------------------------------------------------------%>
        function findIndexOfInspectionOrderDataSourceByInspectionID(inspectionID) {
            for (var index = 0; index < GLOBAL_INSPECTION_ORDER_GRID.length; i++) {
                if (GLOBAL_INSPECTION_ORDER_GRID[index].INSPECTIONID == inspectionID) {
                    return index;
                }
            }
        }
        function onclick_MoveUpInspection(SelectedInspectionID, SortOrder) {
            var secondInspection = GLOBAL_INSPECTION_ORDER_GRID[(findIndexOfInspectionOrderDataSourceByInspectionID(SelectedInspectionID) + 1)];
        }

        function onClick_editInspectionOrder() {
            $("#btn_editInspectionOrder").hide();
            $("#btn_hideInspectionOrderGrid").show();
            $("#orderGridWrapper").show();
        }

        function onClick_hideInspectionOrder() {
            $("#orderGridWrapper").hide();
            $("#btn_hideInspectionOrderGrid").hide();
            $("#btn_editInspectionOrder").show();

        }

        function onClick_editHeaderData() {
            var loaderType = $("#grid").data("data-CurrentLoadType");
            var inspectionType = $("#grid").data("data-CurrentInspectionType");
            var is2Runner = $("#grid").data("data-is2Runner");
            var inspectionTypeIndex;
            var isNewInspection = $("#dwEditInspectionHeader").data("data-isNewInspection");
            var selectedInspection = $("#cboxInspectionList").val();

            if (isNewInspection == true) {
                selectedInspection = $("#grid").data("data-NewInspectionName");
                inspectionType = $("#grid").data("data-newInspection_InspectionType");
                loaderType = $("#grid").data("data-newInspection_LoadType");
                is2Runner = $("#grid").data("data-is2Runner");

                $("#txtBoxInspectionName").val(selectedInspection); 
                $("#cboxInspectionTypes").igCombo("value", inspectionType);
                $("#cboxLoadTypes").igCombo("value", loaderType);
                $("#chBoxValidation").prop("checked", is2Runner);
                $("#dwEditInspectionHeader").igDialog("open");
                
            }
            else{

                $("#txtBoxInspectionName").val(selectedInspection);
                inspectionTypeIndex = GLOBAL_INSPECTIONTYPES.map(function (e) { return e.INSPECTIONLABEL }).indexOf(inspectionType);
                $("#cboxInspectionTypes").igCombo("value", GLOBAL_INSPECTIONTYPES[inspectionTypeIndex].ID);

                var loadTypeIndex = GLOBAL_LOADTYPES.map(function (e) { return e.LOADTYPETEXT }).indexOf(loaderType);
                $("#cboxLoadTypes").igCombo("value", GLOBAL_LOADTYPES[loadTypeIndex].LOADTYPE);
                $("#chBoxValidation").prop("checked", is2Runner);
                $("#btn_addNewInspection").attr("disabled", "disabled");
                $("#btn_deleteHeaderDetails").attr("disabled", "disabled");
                $("#dwEditInspectionHeader").igDialog("open");
            }
        }
        
        function onClick_addNewInspection() {
            <%--if "add new inspection" is choosen--%>
            $("#txtBoxInspectionName").val("");
            $("#cboxInspectionList").igCombo("value", null);
                $("#cboxInspectionTypes").igCombo("value", null);
                $("#cboxLoadTypes").igCombo("value", null);
                $("#chBoxValidation").prop("checked", false);
                $("#lblInspectionType").text("");
                $("#lblLoadType").text("");
                $("#lblIs2Runner").text("");
                $("#tblInspectionListDetails").hide();
                $("#grid").igGrid("dataBind");
                $("#gridWrapper").hide();
                $("#dwEditInspectionHeader").data("data-isNewInspection", true);
                $("#dwEditInspectionHeader").data("data-CurrentInspectionID", 0);
                $("#btn_deleteHeaderDetails").attr("disabled", "disabled");
                $("#btn_cancelNewInspection").hide();
                $("#dwEditInspectionHeader").igDialog("open");
                $("#btn_addNewInspection").attr("disabled", "disabled");
        }



        function onClick_deleteHeaderData() {
            var c = confirm("Deleting an inspection can not be undone. Would you like to continue deleting this inspection?");
            if (c == true) {
                var currentInspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");
                $("#tblInspectionListDetails").hide();
                PageMethods.disableInspection(currentInspectionID, onSuccess_disableInspection, onFail_disableInspection);
            }

        }

        function onClick_cancelNewInspection() {
            GLOBAL_INSPECTION_LIST.shift();
            $("#cboxInspectionList").igCombo("option", "dataSource", GLOBAL_INSPECTION_LIST);
            $("#cboxInspectionList").igCombo("dataBind");
            $("#cboxInspectionList").igCombo("value", -1);
            GLOBAL_GRID_DATA = [];
            $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA);
            $("#grid").igGrid("dataBind");
            $("#gridWrapper").hide();
            $("#dwEditInspectionHeader").data("data-isNewInspection", false);
            $("#cboxLoadTypes").igCombo("selectedIndex", -1);
            $("#cboxInspectionTypes").igCombo("selectedIndex", -1);
            $("#txtBoxInspectionName").val('');
            $("#lblInspectionType").text("");
            $("#lblLoadType").text("");
            $("#lblIs2Runner").text("");
            $("#btn_deleteHeaderDetails").attr("disabled", "disabled");
            $("#btn_cancelNewInspection").hide();
        }


        function onClick_SaveInspectionHeaderEdits() {
            var isNewInspection = $("#dwEditInspectionHeader").data("data-isNewInspection");
            var inspectionName = $("#txtBoxInspectionName").val();
            var inspectionType = $("#cboxInspectionTypes").val();
            var loadType = $("#cboxLoadTypes").val();
            var is2Runner;

            //first make sure everything is filled out 
            if (checkNullOrUndefined(inspectionName) == true) {
                alert("Inspection name can not be blank.");
                return false;
            }

            if (checkNullOrUndefined(inspectionType) == true) {
                alert("Inspection type can not be blank.");
                return false;
            }

            if (checkNullOrUndefined(loadType) == true) {
                alert("Load type can not be blank.");
                return false;
            }

            var checkBoxVal = $("#chBoxValidation").is(':checked');
            if (checkBoxVal == false) {
                is2Runner = "No";
            }
            else {
                is2Runner = "Yes";
            }

            //get keys for inspection
            var inspectionTypeIndex = GLOBAL_INSPECTIONTYPES.map(function (e) { return e.INSPECTIONLABEL }).indexOf(inspectionType);
            var inspectionType = GLOBAL_INSPECTIONTYPES[inspectionTypeIndex].ID;

            var loadTypeIndex = GLOBAL_LOADTYPES.map(function (e) { return e.LOADTYPETEXT }).indexOf(loadType);
            var loadType = GLOBAL_LOADTYPES[loadTypeIndex].LOADTYPE;


            $("#lblInspectionType").text(GLOBAL_INSPECTIONTYPES[inspectionTypeIndex].INSPECTIONLABEL);
            $("#lblLoadType").text(GLOBAL_LOADTYPES[loadTypeIndex].LOADTYPETEXT);
            $("#lblIs2Runner").text(is2Runner);

            $("#tblInspectionListDetails").show();

            if (isNewInspection == true) {
                GLOBAL_GRID_DATA = [];
                $("#grid").igGrid("dataBind");
                $("#dwEditInspectionHeader").igDialog("close");

                $("#grid").data("data-NewInspectionName", inspectionName);
                $("#grid").data("data-isFirstTestOfANewInspection", true);
                $("#grid").data("data-newInspection_InspectionType", inspectionType);
                $("#grid").data("data-newInspection_LoadType", loadType);
                $("#grid").data("data-is2Runner", checkBoxVal);

                $("#txtBoxInspectionName").val("");
                $("#cboxInspectionTypes").igCombo("value", null);
                $("#cboxLoadTypes").igCombo("value", null);
                //$("#btn_deleteHeaderDetails").removeAttr('disabled');
                //$("#btn_cancelNewInspection").removeAttr('disabled');
                alert("Inspection will be created after its first test has been added.");
                PageMethods.getInspectionList(onSuccess_getInspectionList, onFail_getInspectionList, inspectionName);

            }
            else {
                $("#btn_deleteHeaderDetails").removeAttr('disabled');
                $("#btn_cancelNewInspection").removeAttr('disabled');
                var currentID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");
                PageMethods.updateInspectionHeader(currentID, inspectionName, inspectionType, loadType, checkBoxVal, onSuccess_updateInspectionHeader, onFail_updateInspectionHeader, currentID);
            }
        }
        function onClick_CancelInspectionHeaderEdit() {
            $("#dwEditInspectionHeader").igDialog("close");
            $("#cboxInspectionList").igCombo("selectedIndex", -1);
            $("#btn_addNewInspection").removeAttr('disabled');
            $("#btn_editHeaderDetails").removeAttr('disabled');
            $("#btn_deleteHeaderDetails").removeAttr('disabled');
        }


        function searchInspectionList(inspectionHeaderID) {
            for (var i = 0; i < GLOBAL_INSPECTION_LIST.length; i++) {
                if (GLOBAL_INSPECTION_LIST[i].ID == inspectionHeaderID) {
                    return i;
                }
            }
        }


        function onSuccess_setNewSortOrder(value, ctx, methodName) {
            var counter = $("#grid").data("data-indexCounter");
            var totalInspectionsOnList = $('#grid > tbody  > tr').length;
            if (counter == totalInspectionsOnList) {
                var InspectionHeaderID = $("#cboxInspectionList").igCombo("value");
                PageMethods.getAdminInspectGridData(InspectionHeaderID, onSuccess_getAdminInspectGridData, onFail_getAdminInspectGridData);
                $("#grid").data("data-indexCounter", 1);
            }
            else if (checkNullOrUndefined(counter) == true) {
                $("#grid").data("data-indexCounter", 2);
            }
            else {
                counter++;
                $("#grid").data("data-indexCounter", counter);
            }
        }
        function onFail_setNewSortOrder(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_setNewSortOrder");
        }
       

         <%-------------------------------------------------------
        Initialize Infragistics IgniteUI Controls
        -------------------------------------------------------%>

        function initGrid() {
            $("#grid").igGrid({
                dataSource: GLOBAL_GRID_DATA,
                width: "99%",
                virtualization: false,
                autoGenerateColumns: true,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "TESTID",
                columns:
                    [
                        { headerText: "", key: "TESTID", dataType: "number", hidden: true, width:"0px" },
                        { headerText: "Order", key: "SORTORDER", dataType: "number", width: "60px" },
                        { headerText: "Test Text", key: "TESTTEXT", dataType: "string",width:"1550px" },
                        { headerText: "Is a Deal Breaker Question", key: "ISDEALBREAKER", dataType: "bool", width: "150px" }
                    ],
                features: [
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
                    },
                    {
                        name: 'Updating',
                        enableAddRow: true,
                        editMode: 'row',
                        enableDeleteRow: true,
                        showReadonlyEditors: false,
                        enableDataDirtyException: false,
                        autoCommit: false,
                        editRowEnding: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }
                            if ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) {

                                var newTest = ui.values.TESTTEXT.toLowerCase().replace(/\s/g, '');
                                for (var i = 0; i < GLOBAL_GRID_DATA.length; i++) {
                                    var testingTest = GLOBAL_GRID_DATA[i].TESTTEXT.toLowerCase().replace(/\s/g, '');
                                    if (newTest == testingTest && (ui.rowID != GLOBAL_GRID_DATA[i].TESTID)) {
                                        alert('A test with that text already exsist. Test text must be unique.');
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                }
                                if (ui.update == true && ui.rowAdding == true) {//adding

                                    var isFirstTestOfNewInspection = $("#grid").data("data-isFirstTestOfANewInspection");

                                if (isFirstTestOfNewInspection == true) {
                                    var inspectionType = $("#grid").data("data-newInspection_InspectionType");
                                    var loadType = $("#grid").data("data-newInspection_LoadType");
                                    if (loadType == 'both') {
                                        loadType = 'BOTH';
                                    }
                                    var inspectionHeaderName = $("#grid").data("data-NewInspectionName");
                                    var is2Runner = $("#grid").data("data-is2Runner");
                                    //add sort order

                                    PageMethods.setNewInspectionSetNewTestAndAssociate(inspectionHeaderName, inspectionType, loadType, is2Runner, 1, ui.values.TESTTEXT, ui.values.ISDEALBREAKER,
                                                                    onSuccess_setNewInspectionSetNewTestAndAssociate, onFail_setNewInspectionSetNewTestAndAssociate, ui.values.TESTID);
                                }
                                else {
                                    var inspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");
                                    var sortOrder = $('#grid > tbody  > tr').length;
                                    PageMethods.setNewTestAndAssociateToInspection(inspectionID, (sortOrder + 1), ui.values.TESTTEXT, ui.values.ISDEALBREAKER,
                                                        onSuccess_setNewTestAndAssociateToInspection, onFail_setNewTestAndAssociateToInspection, ui.values.TESTID);
                                    }
                                }
                                else if (ui.update == true && ui.rowAdding == false) {//updating
                                    var inspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");
                                    PageMethods.updateTest(inspectionID, ui.rowID, ui.values.TESTTEXT, ui.values.ISDEALBREAKER, onSuccess_updateTest, onFail_updateTest);
                            }
                        }
                            else {
                                return false;
                            }
                        },
                        rowDeleting: function (evt, ui) {
                            var inspectionID = $("#dwEditInspectionHeader").data("data-CurrentInspectionID");
                            PageMethods.checkIfLastTestAndDisable(inspectionID, onSuccess_checkIfLastTestAndDisable, onFail_checkIfLastTestAndDisable, ui.rowID);
                            return false;

                        },
                        columnSettings:
                            [{ columnKey: "TESTID", readOnly: false, required: true },
                                { columnKey: "TESTTEXT", readOnly: false, required: true },
                                {
                                    columnKey: "SORTORDER",
                                    readOnly: true,

                                    //editorType: "numeric",
                                    //required: true,
                                    //editorOptions: {
                                    //    dataMode: "int",
                                    //    maxDecimals: 0,
                                    //    minValue: 00,
                                    //    button: 'spin',
                                    //    minValue: 1,
                                    //    required: true,
                                    //}
                                }
                            ]
                    }
                ],
                rowsRendered: function (evt, ui) {
                    // initialize sortable on the grid tbody
                    initSortable();
                }

            }); <%--end of $("#grid").igGrid({--%>
            GLOBAL_GRID_EXIST = true;
            $("#gridWrapper").hide();
        } <%--end of initGrid()--%>



        $(function () {
            $("#btn_deleteHeaderDetails").attr("disabled", "disabled");
            $("#btn_cancelNewInspection").hide();
            $("#orderGridWrapper").hide();
            $("#btn_hideInspectionOrderGrid").hide();
            $("#tblInspectionListDetails").hide();

            $("#txtBoxInspectionName").change(function () {
                var inspectionName = $("#txtBoxInspectionName").val();
                if (checkNullOrUndefined(inspectionName) == false) {
                    PageMethods.checkInspectionHeaderName(inspectionName, onSuccess_checkInspectionHeaderName, onFail_checkInspectionHeaderName, inspectionName);
                }
            });
            $("#cboxInspectionList").igCombo({
                dataSource: null,
                textKey: "LABEL",
                valueKey: "ID",
                width: "400px",
                mode: "editable",
                highlightMatchesMode: "contains",
                filteringCondition: "contains",
                autoSelectFirstMatch: false,
                selectionChanged: function (evt, ui) {
                    $("#dwEditInspectionHeader").igDialog("close");
                    <%--if combo box is empty, reset vars and hide HTML--%>
                    if (ui.items.length === 0) {
                        GLOBAL_GRID_DATA = [];
                        $("#dwEditInspectionHeader").data("data-CurrentInspectionID", 0);
                        $("#dwEditInspectionHeader").data("data-CurrentInspectionName", "");
                        $("#dwEditInspectionHeader").data("data-isNewInspection", false);
                        $("#lblInspectionType").text("");
                        $("#lblLoadType").text("");
                        $("#lblIs2Runner").text("");
                        $("#tblInspectionListDetails").hide();
                        $("#grid").igGrid("option", "dataSource", null);
                        $("#grid").igGrid("dataBind");
                        $("#gridWrapper").hide();
                        $("#btn_deleteHeaderDetails").attr("disabled", "disabled");
                        $("#btn_cancelNewInspection").hide();
                        $("#btn_addNewInspection").show();
                    }
                    else if (ui.items[0].data.ID == -1) {
                            var inspectionType = $("#dwEditInspectionHeader").data("data-InspectionType");
                            $("#btn_deleteHeaderDetails").removeAttr('disabled');
                            $("#btn_deleteHeaderDetails").removeAttr('disabled');
                            $("#tblInspectionListDetails").show();
                            $("#grid").igGrid("option", "dataSource", null);
                            $("#grid").igGrid("dataBind");
                            $("#grid").igGrid("commit");
                            $("#cboxInspectionTypes").igCombo("value", inspectionType);
                            $("#btn_deleteHeaderDetails").removeAttr('disabled');
                            $("#btn_cancelNewInspection").removeAttr('disabled');
                            $("#btn_deleteHeaderDetails").attr("disabled", "disabled");
                            $("#gridWrapper").show();
                        }
                        else {
                            <%--if a inspection is choosen --%>
                            GLOBAL_INSPECTIONID = ui.items[0].data.ID;
                            GLOBAL_INSPECTIONNAME = ui.items[0].data.LABEL;
                            $("#dwEditInspectionHeader").data("data-CurrentInspectionID", ui.items[0].data.ID);
                            $("#dwEditInspectionHeader").data("data-CurrentInspectionName", ui.items[0].data.LABEL);

                            $("#tblInspectionListDetails").show();
                            <%--set lables for viewing inspection --%>
                            var index = searchInspectionList(ui.items[0].data.ID);
                            var loadType = GLOBAL_INSPECTION_LIST[index].LOADTYPE;
                            var inspectionType = GLOBAL_INSPECTION_LIST[index].INSPECTIONTYPE;
                            var is2Runner = GLOBAL_INSPECTION_LIST[index].is2Runner;

                            $("#grid").data("data-CurrentLoadType", loadType);
                            $("#grid").data("data-CurrentInspectionType", inspectionType);
                            $("#grid").data("data-is2Runner", is2Runner);

                            GLOBAL_LOADTYPE = inspectionType;
                            if (is2Runner == false) {
                                is2Runner = "No";
                            }
                            else { is2Runner = "Yes"; }

                            $("#lblLoadType").text(loadType);
                            $("#lblInspectionType").text(inspectionType);
                            $("#lblIs2Runner").text(is2Runner);
                            $("#btn_addNewInspection").removeAttr('disabled');
                            $("#btn_editHeaderDetails").removeAttr('disabled');
                            $("#btn_deleteHeaderDetails").removeAttr('disabled');
                            $("#btn_cancelNewInspection").hide();
                            PageMethods.getAdminInspectGridData(GLOBAL_INSPECTIONID, onSuccess_getAdminInspectGridData, onFail_getAdminInspectGridData);
                        }
                }
            });

            $("#cboxInspectionTypes").igCombo({
                dataSource: null,
                textKey: "INSPECTIONLABEL",
                valueKey: "ID",
                width: "250px",
                autoComplete: true,
                nullText: "",
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        var isNewInspection = $("#dwEditInspectionHeader").data("data-isNewInspection");
                        var inValidName = $("#dwEditInspectionHeader").data("data-inValidName");
                        var currentInspectionType = $("#cboxInspectionTypes").val();
                        var currentLoadType = $("#cboxLoadTypes").val();
                        $("#dwEditInspectionHeader").data("data-InspectionType", ui.items[0].data.ID);
                    }
                }
            });

            $("#cboxLoadTypes").igCombo({
                dataSource: null,
                textKey: "LOADTYPETEXT",
                valueKey: "LOADTYPE",
                width: "250px",
                autoComplete: true,
                nullText: "",
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        var inValidName = $("#dwEditInspectionHeader").data("data-inValidName");
                        var currentInspectionType = $("#cboxInspectionTypes").val();
                        var currentLoadType = $("#cboxLoadTypes").val();
                        $("#dwEditInspectionHeader").data("data-LoadType", ui.items[0].data.ID);
                        if (inValidName != true && checkNullOrUndefined(currentInspectionType) == false && checkNullOrUndefined(currentLoadType) == false) {
                        }
                    }
                    else {
                    }
                }
            });

            $("#dwEditWarningDialogBox").igDialog({
                width: "400px",
                height: "250px",
                state: "closed",
                closeOnEscape: false,
                showCloseButton: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {
                        if (GLOBAL_ALLOW_TEST_CHANGES === true) {
                        }
                    }
                    else if (ui.action === "open") {
                    }
                }

            }); //end of $("#dwEditWarningDialogBox").igDialog({



            $("#dwEditInspectionHeader").igDialog({
                width: "500px",
                height: "300px",
                state: "closed",
                closeOnEscape: false,
                showCloseButton: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {
                        var isNewInspection = $("#dwEditInspectionHeader").data("data-isNewInspection");
                        if (isNewInspection == true) {
                            //check to see if name exist
                            var inspectionType = $("#dwEditInspectionHeader").data("data-InspectionType");
                            var loadType = $("#dwEditInspectionHeader").data("data-LoadType");
                            $("#grid").data("data-isFirstTestOfANewInspection", true);
                            $("#grid").data("data-newInspection_InspectionType", inspectionType);
                            $("#grid").data("data-newInspection_LoadType", loadType);
                        }
                    }
                    else if (ui.action === "open") {
                    }
                }

            }); //end of $("#dwEditInspectionHeader").igDialog({

            PageMethods.getInspectionList(onSuccess_getInspectionList, onFail_getInspectionList);

        }); <%--end $(function () --%>
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
        
      <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>



    <div id="InspectionHeaderOptionsAndButtons">
        <div><h2>Create a new inspection</h2><button type="button" id="btn_addNewInspection" onclick='onClick_addNewInspection()'>Add New Inspection</button></div>
        <button type="button" id="btn_cancelNewInspection" onclick='onClick_cancelNewInspection()'>Cancel New Inspection</button>
        <h2>Or select an inspection from the drop down list to edit</h2>
        <input id="cboxInspectionList" /><div id="AdminDeleteButton"></div>
    </div>

    <table id="tblInspectionListDetails">
        <tr><td><h2>Inspection Details:</h2></td></tr>
        <tr><td>Inspection Type: </td><td><label id="lblInspectionType"></label></td></tr>
        <tr><td>For Load Type: </td><td><label id="lblLoadType"></label></td></tr>
        <tr><td>Requires a 2nd (Validation) Run: </td><td><label id="lblIs2Runner"></label></td></tr>
        <tr><td><button type="button" id="btn_editHeaderDetails" onclick='onClick_editHeaderData()'>Edit Inspection Details</button></td>
            <td><button type="button" id="btn_deleteHeaderDetails" onclick='onClick_deleteHeaderData()'>Delete Inspection</button></td>
        </tr>
    </table>

        <br/>
        <br/>
    <div id="gridWrapper">
        <table id="grid"></table>
    </div>

    
    
    <div id ="dwEditInspectionHeader">
        <table>
            <tr><td>
                <label>Inspection Name (100 character max): </label></td><td>
                <input type="text" id="txtBoxInspectionName" style="width: 250px; height: 30px;" maxlength="100" \ />
			</td></tr>
            <tr><td></td></tr>
            <tr><td>
                <label>Inspection Type: </label></td><td>
                <input id="cboxInspectionTypes" style="padding-top:1%"  />
            </td></tr>
			<tr><td></td></tr>
			<tr><td>
                <label>For Load Type: </label></td><td>
			    <input id="cboxLoadTypes" style="padding-top:1%" />
            </td></tr>
			<tr><td></td></tr>
			<tr><td>
                <label>Requires a 2nd (Validation) Run: </label></td><td>
                <input type="checkbox" id="chBoxValidation" /></td></tr>
			<tr><td></td></tr>
            <tr><td></td></tr>
			<tr><td>
			<button type="button" id="btnEdtInspctHeader" onclick='onClick_SaveInspectionHeaderEdits()'>Save</button>
			<button type="button" id="btnCnclInspctHeader" onclick='onClick_CancelInspectionHeaderEdit()'>Cancel</button>
			</td></tr>
        </table>
    </div>
    
</asp:Content>
