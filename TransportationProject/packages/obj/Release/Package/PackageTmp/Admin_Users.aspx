<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_Users.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_Users" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Users</h2>
    <h3>View, add, update, and delete users including password and alert settings.</h3>
     <script type="text/javascript">
        
        
        <%-------------------------------------------------------
        Globals & RegEx Patterns
        -------------------------------------------------------%>
        var GLOBAL_CELLULARPROVIDER_OPTIONS = [];
        var GLOBAL_GRID_DATA = [];
        var data = [];
        var emailPattern = new RegExp(/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i);
        var phoneNumberPattern = new RegExp(/^[2-9][0-9]{2}[2-9][0-9]{2}[0-9]{4}$/);
        var tempUserID = 0;
        var rowID = 0;
        var updatePasswordDecision = null;

        
        
        <%-------------------------------------------------------
        Pagemethods Handlers
        -----------------------------------------------------------%>

        function onSuccess_getUsersGridData(value, ctx, methodName) {
            GLOBAL_GRID_DATA.length = 0;
            var cProvider;
            var cPhone;
            if (value != null) {
                for (i = 0; i < value.length; i++) {
                    
                    if (value[i][6])<%--handles if cellProvider is null--%>
                    { cProvider = value[i][6]; }
                    else { cProvider = 0; }

                    if (value[i][5])<%--handles if cellPhone is null--%>
                    { cPhone = value[i][5]; }
                    else { cPhone = ""; }


                    GLOBAL_GRID_DATA[i] = {
                    "USERID": value[i][0], "USERNAME": value[i][1], "FIRSTNAME": value[i][2], "LASTNAME": value[i][3], "EMAIL": value[i][4], "CELLPHONENUMBER": cPhone,
                    "CELLULARPROVIDER": cProvider, "ADMIN": value[i][7], "DOCKMANAGER": value[i][8], "INSPECTOR": value[i][9], "GUARD": value[i][10], "LABPERSONEL": value[i][11],
                    "LOADER": value[i][12], "YARDMULE": value[i][13], "REPORTER": value[i][14], "LABADMIN": value[i][15], "ACCTMANAGER": value[i][16], "ASBUTTON": "", "RPBUTTON": ""
                    };
                }
            }
            <%--After dropdown box data are  retrieved and set to global vars, initialize grid --%>
            initGrid();

        }
         function onFail_getUsersGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Users.aspx, onFail_getUsersGridData");
        }

        function onSuccess_setNewUser(value, UserName, methodName) {
            $("#grid").igGridUpdating("setCellValue", tempUserID, 'USERID', value);
            $("#grid").igGrid("commit");
            alert("New user created with the username: \"" + UserName + "\" and a password of \"ZXPpassword1!\" To change the password, click on \"reset password\" on the row associated with this user.");
        }

        function onFail_setNewUser(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Users.aspx, onFail_setNewUser");
        }

        function onSuccess_getCellularProvider(value, ctx, methodName) {
            GLOBAL_CELLULARPROVIDER_OPTIONS = [];
            for (i = 0; i < value.length; i++) {
                GLOBAL_CELLULARPROVIDER_OPTIONS[i] = { "PROVIDER": value[i][0], "PROVIDERTEXT": value[i][1] };
            }
            GLOBAL_CELLULARPROVIDER_OPTIONS.unshift({ "PROVIDER": 0, "PROVIDERTEXT": '(NONE)' });
            PageMethods.getUsersGridData(onSuccess_getUsersGridData, onFail_getUsersGridData);

        }

        function onFail_getCellularProvider(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Users.aspx, onFail_getCellularProvider");
        }

        function onSuccess_disableUser(value, ctx, methodName) {
            $("#grid").igGridUpdating("deleteRow", ctx);
            $("#grid").igGrid("commit");
        }

        function onFail_disableUser(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Users.aspx, onFail_disableUser");
        }

        function onSuccess_updateUser(value, ctx, methodName) {
            $("#grid").igGrid("commit");
        }

        function onFail_updateUser(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Users.aspx, onFail_updateUser");
        }

        function onSuccess_updatePassword(value, ctx, methodName) {
            $("#grid").igGrid("commit");
        }

        function onFail_updatePassword(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Users.aspx, onFail_updatePassword");
        }

        <%-------------------------------------------------------
        Format methods
        -----------------------------------------------------------%>
        function phoneFormatter(val) {
            if (!val)
                return "";
            else if ($.isNumeric(val) == false)
                return "";
            else {
                var newPhone = val;
                newPhone = newPhone.replace(/(\d{3})(\d{3})(\d{4})/, "($1) $2-$3");
                return newPhone;
            }
        }<%-- end of phoneFormatter(val) {--%>
        
        function formatCellProvidersCombo(val) {
            var i, phone;
            for (i = 0; i < GLOBAL_CELLULARPROVIDER_OPTIONS.length; i++) {
                phone = GLOBAL_CELLULARPROVIDER_OPTIONS[i];
                if (phone.PROVIDER == val) {
                    val = phone.PROVIDERTEXT;
                }
            }
            return val;
        }

        function onClick_StoreIDAndRedirect(userID) {
            sessionStorage.setItem("userID_Alerts", userID);

            var uName = $("#grid").igGrid("getCellValue", userID, "USERNAME");
            var cellPhone = $("#grid").igGrid("getCellValue", userID, "CELLPHONENUMBER");

            sessionStorage.setItem("uName_Alerts", uName);
            if (checkNullOrUndefined(cellPhone) == true) {
                sessionStorage.setItem("hasCell_Alerts", false);
            }
            else {
                sessionStorage.setItem("hasCell_Alerts", true);
            }

            location.href = '/Admin_UserAlerts.aspx';
        }
         
        function onClick_ResetPassword(userID) {
            $("#editPassword").data("data-userID", userID);
            var userName = $("#grid").igGrid("getCellValue", userID, "USERNAME");
            var title = "Password reset for " + userName;
            $("#question").attr("title", title);
            var firstName = $("#grid").igGrid("getCellValue", userID, "FIRSTNAME");
            var lastName = $("#grid").igGrid("getCellValue", userID, "LASTNAME");
            $("#question").text("You are about to reset the password for " + firstName + " " + lastName + "." );
            $("#editPassword").igDialog("open");

        }

        function onClick_ResetPasswordConfirm() {
            $("#editPassword").igDialog("close");
            PageMethods.updateUser(userID, onSuccess_updateUser, onFail_updateUser);
        }

        <%-------------------------------------------------------
        Initialize Infragistics IgniteUI Controls
        -------------------------------------------------------%>


         $(window).resize(function () {
             $("#editPassword").dialog("option", "position", "center");
         });

        function initGrid() {
            $("#grid").igGrid({
                dataSource: GLOBAL_GRID_DATA,
                width: "100%",
                virtualization: false,
                autofitLastColumn: true,
                autoGenerateColumns: true,
                renderCheckboxes: true,
                primaryKey: "USERID",
                columns:
                    [
                        { headerText: "", key: "USERID", dataType: "number", hidden: true, width:"0px"},
                        { headerText: "First Name", key: "FIRSTNAME", dataType: "string",width:"175px"},
                        { headerText: "Last Name", key: "LASTNAME", dataType: "string", width: "175px" },
                        { headerText: "Username", key: "USERNAME", dataType: "string", width: "200px" },
                        { headerText: "E-mail Address", key: "EMAIL", dataType: "string", width: "200px" },
                        { headerText: "Cell Phone Number", key: "CELLPHONENUMBER", dataType: "string", formatter: phoneFormatter, width: "125px" },
                        { headerText: "Cell Phone Provider", key: "CELLULARPROVIDER", dataType: "number", formatter: formatCellProvidersCombo, width: "150px" },
                        { headerText: "Admin", key: "ADMIN", dataType: "bool", width: "50px" },
                        { headerText: "Dock Manager", key: "DOCKMANAGER", dataType: "bool", width: "70px" },
                        { headerText: "Inspector", key: "INSPECTOR", dataType: "bool", width: "70px" },
                        { headerText: "Guard", key: "GUARD", dataType: "bool", width: "50px'" },
                        { headerText: "Lab Personnel", key: "LABPERSONEL", dataType: "bool", width: "70px" },
                        { headerText: "Lab Admin", key: "LABADMIN", dataType: "bool", width: "60px" },
                        { headerText: "Loader", key: "LOADER", dataType: "bool", width: "50px" },
                        { headerText: "Yard Mule", key: "YARDMULE", dataType: "bool", width: "50px" },
                        { headerText: "Account Manager", key: "ACCTMANAGER", dataType: "bool", width: "50px" },
                        { headerText: "Can View Reports?", key: "REPORTER", dataType: "bool", width: "80px" },
                        {
                            headerText: "Reset Password", key: "RPBUTTON", width: "125px",
                            template: "<input id=${USERID}_btnPassword type='button' value='Reset Password' onclick = onClick_ResetPassword(${USERID})>"
                        },
                        {
                            headerText: "Alert Settings", key: "ASBUTTON", width: "60px",
                            template: "<input id=${USERID}_btnAlerts type='button' value='Alerts' onclick = onClick_StoreIDAndRedirect(${USERID})>"
                        }



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
                        editCellStarting: function (evt, ui) {
                            if (ui.columnKey == "ASBUTTON"|| ui.columnKey == "RPBUTTON" ) {
                                return false;
                            }
                        },
                        editRowEnding: function (evt, ui) {
                            tempUserID = 0;
                            var roleCounter = 0;
                            var origEvt = evt.originalEvent;
                            var cellPhoneNumberAsInt;
                            var cellPhoneNumberProvider;
                            if (ui.values.ADMIN == true) { roleCounter++ }
                            if (ui.values.DOCKMANAGER == true) { roleCounter++ }
                            if (ui.values.INSPECTOR == true) { roleCounter++ }
                            if (ui.values.GUARD == true) { roleCounter++ }
                            if (ui.values.LABPERSONEL == true) { roleCounter++ }
                            if (ui.values.LOADER == true) { roleCounter++ }
                            if (ui.values.YARDMULE == true) { roleCounter++ }
                            if (ui.values.LABADMIN == true) { roleCounter++ }
                            if (ui.values.REPORTER == true) { roleCounter++ }
                            if (ui.values.ACCTMANAGER == true) { roleCounter++ }


                            <%--checks to see if a user has both cell # and provider or neither--%>

                            if (ui.update == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                if (roleCounter == 0) {
                                    alert("There must be at least one role selected per user.");
                                    ui.keepEditing = true;
                                    return false;
                                }
                                if (checkNullOrUndefined(ui.values.CELLPHONENUMBER) === false) {
                                    cellPhoneNumberAsInt = parseInt(ui.values.CELLPHONENUMBER);
                                }
                                else {
                                    cellPhoneNumberAsInt = null;
                                }
                                if (ui.values.CELLULARPROVIDER == 0) {
                                    cellPhoneNumberProvider = null;
                                }
                                else {
                                    cellPhoneNumberProvider = ui.values.CELLULARPROVIDER;
                                }


                                if (checkNullOrUndefined(cellPhoneNumberAsInt) === false && checkNullOrUndefined(cellPhoneNumberProvider) === true) {
                                    ui.keepEditing = true;
                                    alert("You have provided a cell phone number but no cell phone provider. Please add a cell phone provider or remove the cell phone number to continue.");
                                    return false;
                                }
                                else if (checkNullOrUndefined(cellPhoneNumberAsInt) === true && checkNullOrUndefined(cellPhoneNumberProvider) === false) {
                                    ui.keepEditing = true;
                                    alert("You have provided a cell phone provider but no cell phone number. Please add a cell phone number or remove the cell phone provider to continue.");
                                    return false;
                                }

                                for (var i = 0; i < GLOBAL_GRID_DATA.length; i++) {
                                    if (ui.values.USERNAME.toLowerCase() === GLOBAL_GRID_DATA[i].USERNAME.toLowerCase()) {
                                        if (GLOBAL_GRID_DATA[i].USERID != ui.rowID) {
                                            ui.keepEditing = true;
                                            alert("There is another user with the username " + ui.values.USERNAME + ". Please rename and try again.");
                                            isValidName = false;
                                            return false;
                                        }
                                    }
                                }
                                for (var i = 0; i < GLOBAL_GRID_DATA.length; i++) {
                                    if (ui.values.EMAIL.toLowerCase() === GLOBAL_GRID_DATA[i].EMAIL.toLowerCase()) {
                                        if (GLOBAL_GRID_DATA[i].USERID != ui.rowID) {
                                            ui.keepEditing = true;
                                            alert("The email address " + ui.values.EMAIL + " is already registed to another user. Please enter a different email address and try agian.");
                                            isValidName = false;
                                            return false;
                                        }
                                    }
                                }


                                //new user added
                                if (ui.update == true && ui.rowAdding == true && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                                    tempUserID = ui.values.USERID;
                                    PageMethods.setNewUser(ui.values.USERNAME, ui.values.FIRSTNAME, ui.values.LASTNAME, ui.values.EMAIL, cellPhoneNumberAsInt, cellPhoneNumberProvider, ui.values.ADMIN, ui.values.DOCKMANAGER, ui.values.INSPECTOR,
                                        ui.values.GUARD, ui.values.LABPERSONEL, ui.values.LOADER, ui.values.YARDMULE, ui.values.LABADMIN, ui.values.REPORTER, ui.values.ACCTMANAGER, onSuccess_setNewUser, onFail_setNewUser, ui.values.USERNAME);
                                }
                                    //edit user
                                else if (ui.update == true && ui.rowAdding == false && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                                    PageMethods.updateUser(ui.rowID, ui.values.USERNAME, ui.values.FIRSTNAME, ui.values.LASTNAME, ui.values.EMAIL,
                                        cellPhoneNumberAsInt, cellPhoneNumberProvider, ui.values.ADMIN, ui.values.DOCKMANAGER, ui.values.INSPECTOR, ui.values.GUARD, ui.values.LABPERSONEL, ui.values.LOADER,
                                        ui.values.YARDMULE, ui.values.LABADMIN, ui.values.REPORTER, ui.values.ACCTMANAGER, onSuccess_updateUser, onFail_updateUser);
                                }
                            }
                            else {
                                //ui.keepEditing = true;
                                return false;
                            }
                              
                        },
                        rowDeleting: function (evt, ui) {
                            tempUserID = 0;
                            tempUserID = $("#grid").igGrid("getCellValue", ui.rowID, "USERID");
                            //rowID = ui.rowID;
                            var firstName = $("#grid").igGrid("getCellValue", ui.rowID, "FIRSTNAME");
                            var lastName = $("#grid").igGrid("getCellValue", ui.rowID, "LASTNAME");

                            var c = confirm("You are about to delete " + firstName + " " + lastName + ". Are you sure you want to delete " + firstName + "? This can not be undone.");

                            if (c == true) {
                                PageMethods.disableUser(ui.rowID, onSuccess_disableUser, onFail_disableUser, ui.rowID);
                                //PageMethods.disableDemurrageAlert(ui.rowID, onSuccess_disableDemurrageAlert, onFail_disableAlert, ui.rowID);
                            }
                            else { return false; }
                            
                            //$("#question").text("You are about to delete " + firstName + " " + lastName + ". Are you sure you want to delete " + firstName + "?");
                            //$("#editPassword").igDialog("open");
                            return false;
                        },
                        columnSettings:
                            [   { columnKey: "USERID", readOnly: false, required:true },
                                { columnKey: "FIRSTNAME", readOnly: false, required:true },
                                { columnKey: "LASTNAME", readOnly: false, required: true },
                                { columnKey: "USERNAME", readOnly: false, required:true },
                                {
                                    columnKey: "CELLULARPROVIDER",
                                    editorType: "combo",
                                    editorOptions: {
                                        mode: "editable",
                                        enableClearButton: false,
                                        dataSource: GLOBAL_CELLULARPROVIDER_OPTIONS,
                                        id: "cboxStatus",
                                        textKey: "PROVIDERTEXT",
                                        valueKey: "PROVIDER",
                                        autoSelectFirstMatch: true
                                    }
                                },
                                {
                                    columnKey: "EMAIL",
                                    readOnly: false,
                                    required: true,
                                    editorType: "text",
                                    editorOptions: {
                                        type: "string",
                                        validation: true,
                                        validatorOptions: {
                                            onblur: true,
                                            onchange: true,
                                            regExp: emailPattern,
                                            errorMessage: "Invalid email address."
                                        }
                                    }
                                },
                                {
                                    columnKey: "CELLPHONENUMBER",
                                    readOnly: false,
                                    editorType: "text",
                                    editorOptions: {
                                        type: "string",
                                        validation: true,
                                        validatorOptions: {
                                            onblur: true,
                                            onchange: true,
                                            regExp: phoneNumberPattern,
                                            errorMessage: "Invalid phone number."
                                        }
                                    }
                                },
                                { columnKey: "ASBUTTON", readOnly: true },
                                { columnKey: "RPBUTTON", readOnly: true }
                            ]
                    }

                ]

            }); <%--end of $("#grid").igGrid({--%>
        }

        $(function () {
            PageMethods.getCellularProvider(onSuccess_getCellularProvider, onFail_getCellularProvider);
            $("#editPassword").igDialog({
                width: "400px",
                height: "250px",
                state: "closed",
                closeOnEscape: false,
                showCloseButton: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {
                        if (updatePasswordDecision == true) {
                            var userID = $("#editPassword").data("data-userID");
                            var password = $("#txtPassword").val();
                            var password2 = $("#txtPasswordConfirm").val();
                            if (password === password2) {
                                $("#txtPassword").val("");
                                $("#txtPasswordConfirm").val("");
                                PageMethods.updatePassword(userID, password, onSuccess_updatePassword, onFail_updatePassword);
                            }
                            else {
                                alert("Passwords must match");
                                $("#txtPassword").val("");
                                $("#txtPasswordConfirm").val("");
                                return false;
                            }
                        }
                        else {
                            $("#txtPassword").val("");
                            $("#txtPasswordConfirm").val("");
                        }
                    }
                    else if (ui.action === "open") {
                    }
                }
            }); //end of $("#editPassword").igDialog({
        }); //end of $(function () {

    </script>
    
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <%--<h2>Select a row to edit a user or click 'Add new row' to add a new user</h2>--%>
        <br />
        <br />
    <div><table id="grid"></table></div>
    <div id ="editPassword">
        <div id="question"></div>
        <br />
        <table>
            <tr><td><label id="newPassword">New password: </label></td><td><input type="password" id="txtPassword"></td></tr>
            <tr><td><label id="newPassword2">Re-enter new password: </label></td><td><input type="password" id="txtPasswordConfirm"></td></tr>
        </table>
        <%--<input type="checkbox" id="showHide">--%>
        <br />
        <br />
        <button type="button" id="keepUserButton" onclick='updatePasswordDecision = false; $("#editPassword").igDialog("close")'>Cancel</button>
        <button type="button" id="disableUserButton" onclick='updatePasswordDecision = true; $("#editPassword").igDialog("close")'>Submit</button>
    </div>

</asp:Content>