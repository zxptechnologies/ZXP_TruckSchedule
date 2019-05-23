<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_Patterns.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_Patterns" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Patterns</h2>
    <h3>View, add, and delete patterns. </h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <script id="FileTemplate" type="text/template">
    <%--<div><div style='float:right;'><div><img src='./Images/triangleDown.png' onclick='onclick_addFile(${PATTERNID});return false;' height='16' width='16'/></div></div></div> --%>
    <%--<div><div style='float:right; padding-right: 5%;'><div><img src='./Images/xclose.png' onclick='onclick_disableFile(${PATTERNID}); return false;' height='16' width='16'/></div></div> --%>
    <div style='float:left'><a href='${PATTERNPATH}${FILENAMENEW}' id='Pattern_${PATTERNID}'>${FILENAME}</a></div></div> 
    </script>

    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_GRID_DATA_PATTERNS_FOR_PRODUCTS = [];
        var GLOBAL_GRID_DATA_PRODUCTS = [];
        var GLOBAL_PATTERNID = 0;
        var GLOBAL_PATTERN_NAME = null;
        var GLOBAL_FILE_NAME = null;
        var GLOBAL_NEW_PATTERN = false;
        var GLOBAL_NEW_PATTERNS = [];
        var GLOBAL_GRID_EXIST = false;
        var GLOBAL_PRODUCT_NAME_OPTIONS = [];
        var GLOBAL_PRODUCT_ID_OPTIONS = [];
        var FILTERTEXTID = "";
        var FILTERTEXTNAME = "";
        var FILTERTEXT = "";
        var GLOBAL_ROWID;

         <%-------------------------------------------------------
        Pagemethods Handlers
        -----------------------------------------------------------%>

        function onSuccess_getPatternGridData(value, ctx, methodName) {
            GLOBAL_GRID_DATA_PATTERNS = [];
            if (value != null) {
                for (i = 0; i < value.length; i++) {
                    GLOBAL_GRID_DATA_PATTERNS[i] = {
                        "PATTERNID": value[i][0], "PATTERNNAME": value[i][1], "PATTERNPATH": value[i][2], "FILENAME": value[i][3], "FILENAMENEW": value[i][4], "DELETE": ""
                    };
                }
            }
            if (GLOBAL_GRID_EXIST == false) {
                initGrid();
            }
            else {
                GLOBAL_NEW_PATTERNS = [];
                $("#gridPatterns").igGrid("option", "dataSource", GLOBAL_GRID_DATA_PATTERNS);
                $("#gridPatterns").igGrid("commit");
            }
            $("#gridProductsOfPattern").hide();
            $("#button_BackToPatterns").hide();
        }
        function onFail_getPatternGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_getPatternGridData");
        }


        function onSuccess_updatePatternName(value, ctx, methodName) {
            $("#gridPatterns").igGrid("commit");
        }
        function onFail_updatePatternName(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_updatePatternName");
        }


        function onSuccess_disablePattern(value, ctx, methodName) {
            $("#gridPatterns").igGridUpdating("deleteRow", GLOBAL_PATTERNID);
            $("#gridPatterns").igGrid("commit");
        }
        function onFail_disablePattern(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_disablePattern");
        }


        function onSuccess_disableProduct(value, ctx, methodName) {
            $("#gridProductsOfPattern").igGridUpdating("deleteRow", ctx);
            $("#gridProductsOfPattern").igGrid("commit");
        }
        function onFail_disableProduct(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_disableProduct");
        }


        function onSuccess_setNewProduct(value, ctx, methodName) {
            $("#gridProductsOfPattern").igGrid("commit");
        }
        function onFail_setNewProduct(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_setNewProduct");
        }


        function onSuccess_updateProduct(value, ctx, methodName) {
            $("#gridProductsOfPattern").igGrid("commit");
        }
        function onFail_updateProduct(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_updateProduct");
        }


        function onSuccess_updatePatternAndProcessFile(value, ctx, methodName) {
            PageMethods.getPatternGridData(onSuccess_getPatternGridData, onFail_getPatternGridData);
        }
        function onFail_updatePatternAndProcessFile(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_updatePatternAndProcessFile");
        }


        function onSuccess_setNewPatternAndProcessFile(value, ctx, methodName) {
            removePatternFromNewPatternList(GLOBAL_PATTERN_NAME);
            PageMethods.getPatternGridData(onSuccess_getPatternGridData, onFail_getPatternGridData);
        }
        function onFail_setNewPatternAndProcessFile(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_setNewPatternAndProcessFile");
        }


        function onSuccess_getProductName(value, ctx, methodName) {
            if (prodName != null) {
                $("#gridProductsOfPattern").igGridUpdating("setCellValue", ctx, "PRODUCTNAME", prodName);
                $("#gridProductsOfPattern").igGrid("dataBind");
                $("#gridProductsOfPattern").igGrid("commit");
            }
        }
        function onFail_getProductName(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_getProductName");
        }
        function onSuccess_processFileAndData(value, ctx, methodName) {
            if (ctx) {

                if ("BOL" === ctx[1]) {
                    //Add entry into DB 
                    PageMethods.addFileDBEntry(ctx[2], "BOL", ctx[0], value[1], value[0], "BOL", onSuccess_addFileDBEntry, onFail_addFileDBEntry, ctx)

                }
                else if ("OTHER" === ctx[1]) {
                    <%--Add OTHER filetype entry into db only happens on add row finished because need to get Detail column--%>
                    <%--add attributes related to grid for use when adding new row --%>
                    $("#gridFiles").data("data-FPath", value[0]);
                    $("#gridFiles").data("data-FNameNew", value[1]);
                    $("#gridFiles").data("data-FNameOld", ctx[0]);

                    <%--change text of add new row's filename column to uploaded file's original name --%>
                    $("#driverInfoDialog tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(ctx[0]);
                }

              <%-- TODO : CALL FUNCTION TO INSERT NEW ENTRY INTO Fileupload table--%>
            }
        }

        function onFail_processFileAndData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Patterns.aspx, onFail_processFileAndData");
        }
        function checkIfNameExsist(patternName) {
            for (var i = 0; i < GLOBAL_GRID_DATA_PATTERNS.length; i++) {
                if (patternName == GLOBAL_GRID_DATA_PATTERNS[i].PATTERNNAME) {
                    return true;
                }
            }
            return false;
        }


        function onclick_disableFile(patternID) {
            GLOBAL_PATTERNID = patternID;
            var fileName = $("#gridPatterns").igGrid("getCellValue", patternID, "FILENAME");
            var patternName = $("#gridPatterns").igGrid("getCellValue", patternID, "PATTERNNAME");
            if (checkNullOrUndefined(fileName) == false && isPatternNew(patternID) == false) {
                var reply = confirm("You are about to delete " + fileName + " doing this will delete " + patternName + " and can not be undone. Would you like to continue deleting " + fileName + "?");
                if (reply) {
                    PageMethods.disablePattern(GLOBAL_PATTERNID, onSuccess_disablePattern, onFail_disablePattern);
                }
            }
            else {
                alert(patternName + " does not have a file associated with it. Please upload a file for this patten to be saved in the system or make another selection.")
            }
        }
        function addToNewPatternsList(patternName, patternID) { //todo check into this - it looks like garbage 
            var arrLength = GLOBAL_NEW_PATTERNS.length;
            if (arrLength > 0) {
                GLOBAL_NEW_PATTERNS[arrLength + 1] = { "PatternName": patternName, "PatternID": patternID };
            }
            else {
                GLOBAL_NEW_PATTERNS[0] = { "PatternName": patternName, "PatternID": patternID };
            }
        }
        function isPatternNew(patternID) {
             <%--checks against new pattern list--%>
            for (var i = 0; i < GLOBAL_NEW_PATTERNS.length; i++) {
                if (patternID == GLOBAL_NEW_PATTERNS[i].PatternID) {
                    return true;
                }
            }
            return false;
        }
        function removePatternFromNewPatternList(patternName) {
            for (var i = 0; i < GLOBAL_NEW_PATTERNS.length; i++) {
                if (patternName == GLOBAL_NEW_PATTERNS[i].PatternName) {
                    GLOBAL_NEW_PATTERNS.splice(i, 1);
                }
            }
        }
        function onclick_addFile(patternID) {
            $("#igUploadPattern_ibb_fp").click();
        }

        $(function () {
            PageMethods.getPatternGridData(onSuccess_getPatternGridData, onFail_getPatternGridData);
            $("#igUploadPattern").igUpload({
                autostartupload: true,
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileSelecting: function (evt, ui) { },
                fileSelected: function (evt, ui) { showProgress(); },
                fileUploaded: function (evt, ui) {
                    //hideProgress();
                    var patternName = null;

                    if (GLOBAL_PATTERNID == 0) {
                        //(isPatternNew(GLOBAL_PATTERNID) == true) {
                        var isPatternNameValid = false;
                        hideProgress();
                        patternName = prompt("Please enter a pattern name:", "");
                        if (patternName === null) {
                            alert("Pattern upload cancelled.")
                            removePatternFromNewPatternList(GLOBAL_PATTERN_NAME);
                            PageMethods.getPatternGridData(onSuccess_getPatternGridData, onFail_getPatternGridData);
                            return; //break out of the function early
                        }
                        while (isPatternNameValid === false) {
                            if (checkNullOrUndefined(patternName)) {
                                patternName = prompt("Pattern Name cannot be empty. Please enter a pattern name:", "");
                            }
                            else if (checkIfNameExsist(patternName)) {
                                patternName = prompt("A pattern already exsit with that the name " + patternName + ". Please enter a patter name:", "");
                            }

                            if ((!checkIfNameExsist(patternName)) && (!checkNullOrUndefined(patternName))) {
                                isPatternNameValid = true;
                            }
                        }
                        PageMethods.setNewPatternAndProcessFile(patternName, ui.filePath, onSuccess_setNewPatternAndProcessFile, onFail_setNewPatternAndProcessFile);
                    }
                    else {

                        var patternID = $("#gridPatterns").data("data-RowID");
                        PageMethods.updatePatternAndProcessFile(patternID, ui.filePath, onSuccess_updatePatternAndProcessFile, onFail_updatePatternAndProcessFile);
                        hideProgress();
                    }
                },
                fileUploadedAborted: function (evt, ui) {
                    hideProgress();
                },
                onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in Admin_Pattern.aspx, igUploadPattern"); },
            });
        }); <%--end $(function () --%>


         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>

        function initGrid() {
            $("#gridPatterns").igGrid({
                dataSource: GLOBAL_GRID_DATA_PATTERNS,
                width: "1500",
                virtualization: false,
                autoGenerateColumns: true,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "PATTERNID",
                columns:
                    [
                        { headerText: " ", key: "PATTERNID", dataType: "number", hidden: true, width: "0px" },
                        { headerText: "Pattern Name", key: "PATTERNNAME", dataType: "string", width: "500px", },
                        { headerText: "Pattern Location", key: "PATTERNPATH", dataType: "string", width: "500px" },
                        { headerText: "File Upload", key: "FUPLOAD", dataType: "string", template: $("#FileTemplate").html(), width: "350px" },
                        { headerText: " ", key: "FILENAME", dataType: "string", hidden: true, width: "0px" },
                        { headerText: " ", key: "FILENAMENEW", dataType: "string", hidden: true, width: "0px", },
                        { headerText: "Delete", key: "DELETE", dataType: "string", width: "5px" }
                    ],
                features: [
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
                        editRowStarted: function (evt, ui) {
                            if (ui.rowAdding) {
                                onclick_addFile("#igUploadPattern");
                                return false;
                            }
                            else {

                            }
                        },
                        editCellStarting: function (evt, ui) {
                            if (ui.rowAdding == false) {
                                GLOBAL_PATTERNID = ui.rowID;
                                $("#gridPatterns").data("data-RowID", ui.rowID);
                                GLOBAL_PATTERN_NAME = $("#gridPatterns").igGrid("getCellValue", ui.rowID, "PATTERNNAME");
                                $("#gridPatterns").data("data-PatternName", GLOBAL_PATTERN_NAME);
                            }
                        },
                        rowDeleting: function (evt, ui) {
                            GLOBAL_PATTERN_NAME = $("#gridPatterns").igGrid("getCellValue", ui.rowID, "PATTERNNAME");
                            GLOBAL_PATTERNID = ui.rowID;
                            //todo re-write confirm
                            var c = confirm("Deleting " + GLOBAL_PATTERN_NAME + " " + "Continue deleting request for " + GLOBAL_PATTERN_NAME + "? Deletion cannot be undone.");
                            if (c == true) {
                                PageMethods.disablePattern(GLOBAL_PATTERNID, onSuccess_disablePattern, onFail_disablePattern);
                            }
                            else {
                                return false;
                            }
                        },
                        editRowEnding: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }

                            GLOBAL_PATTERN_NAME = ui.values.PATTERNNAME;
                            GLOBAL_PATTERNID = ui.values.PATTERNID;
                            var isValidName = true;
                            if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                for (var i = 0; i < GLOBAL_GRID_DATA_PATTERNS.length; i++) {
                                    if (ui.values.PATTERNNAME.toLowerCase() === GLOBAL_GRID_DATA_PATTERNS[i].PATTERNNAME.toLowerCase()) {
                                        if (GLOBAL_GRID_DATA_PATTERNS[i].PATTERNID != ui.rowID) {
                                            ui.keepEditing = true;
                                            alert("There is another pattern named " + ui.values.PATTERNNAME + ". Please rename and try again.");
                                            isValidName = false;
                                            return false;
                                        }
                                    }
                                }
                                if (isValidName === true) {
                                    addToNewPatternsList(ui.values.PATTERNNAME, ui.values.PATTERNID);
                                }
                            }
                            else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                for (var i = 0; i < GLOBAL_GRID_DATA_PATTERNS.length; i++) {
                                    if (ui.values.PATTERNNAME.toLowerCase() === GLOBAL_GRID_DATA_PATTERNS[i].PATTERNNAME.toLowerCase()) {
                                        if (GLOBAL_GRID_DATA_PATTERNS[i].PATTERNID != ui.rowID) {
                                            ui.keepEditing = true;
                                            alert("There is another pattern named " + ui.values.PATTERNNAME + ". Please rename and try again.");
                                            isValidName = false;
                                            return false;
                                        }
                                    }
                                }
                                if (isValidName === true) {
                                    addToNewPatternsList(ui.values.PATTERNNAME, ui.values.PATTERNID);
                                    PageMethods.updatePatternName(ui.rowID, GLOBAL_PATTERN_NAME, onSuccess_updatePatternName, onFail_updatePatternName);
                                }
                            }
                            else {
                                return false;
                            }
                        },
                        columnSettings:
                            [
                                { columnKey: "DELETE", readOnly: true },
                                { columnKey: "PATTERNNAME", required: true },
                                { columnKey: "PATTERNPATH", readOnly: true },
                                { columnKey: "FUPLOAD", readOnly: true },
                            ]
                    }
                ]
            }); <%--end of $("#gridPatterns").igGrid({--%>

            GLOBAL_GRID_EXIST = true;
        }
    </script>


    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
        <br />
        <br />
    <table id="gridPatterns"></table>
    <button type="button" id="button_BackToPatterns" onclick='onClick_BackToPatterns()'>Back To Patterns</button>
    <table id="gridProductsOfPattern"></table>
    <div id="igUploadPattern" style='display: none;'></div>
        <div id="progressBackgroundFilter" style="display:none"></div>
        <div id="processMessage" style=" text-align:center; display:none; border:3px solid black"><br />
        <asp:Label ID="lblProgressText" runat="server" Text="Processing..." ClientIDMode = "Static"></asp:Label>
        <br />
        <img id="imgLoader" alt="Loading" src="Images/loader.gif" /><%--Development Server--%>
            <%--<asp:Image id="imgLoader" runat="server" ImageUrl="~/Images/loader.gif" />--%><%--LIve Server--%>
        </div>
</asp:Content>
