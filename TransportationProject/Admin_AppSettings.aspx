<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_AppSettings.aspx.cs" Inherits="TransportationProject.Admin_AppSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ScriptMode="Release">
    </asp:ScriptManager><link href="Content/sliderStyle.css" rel="stylesheet" />
    <script type="text/javascript">

          
        function onSuccess_getAppSettings(value, ctx, methodName) {
            var validationSetting = value ? true : false;
            $('#isInspectionValidationOn').prop('checked', validationSetting);
           
        }

        function onFail_getAppSettings(value, ctx, methodName) { 
                 sendtoErrorPage("Error in Admin_AppSettings.aspx, onFail_getAppSettings");
        }
        
        function onSuccess_setInspectionValidation(value, ctx, methodName) {
           $("#isInspectionValidationOn").toggle();
        }

        function onFail_setInspectionValidation(value, ctx, methodName) { 
                 sendtoErrorPage("Error in Admin_AppSettings.aspx, onFail_setInspectionValidation");
        }
       
        $(function () {
            //$('#isInspectionValidationOn').change(onchangeToggle('#isInspectionValidationOn'));

            $("#isInspectionValidationOn").change(function () 
            {

                var ischecked = $('#isInspectionValidationOn').prop('checked');
               PageMethods.setInspectionValidation(ischecked, onSuccess_setInspectionValidation, onFail_setInspectionValidation);
              });

            PageMethods.getAppSettings(onSuccess_getAppSettings, onFail_getAppSettings);
        });
    </script>

    


      <h2>Admin: App Settings</h2>
    <h3>View and update application configurations and settings</h3>
        <br />
        <br />
    <h4>
        Inspection Validation On
    </h4>
    <div>
        <label>Off</label>
        <label class="switch">
        <input id="isInspectionValidationOn" type="checkbox"/>
        <span class="slider round"></span>
        </label>
        <label>On</label>
    </div>
    



</asp:Content>
