<%@ Page Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true"CodeBehind="Admin_Weights.aspx.cs" Inherits="TransportationProject.Admin_Weights" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Weights</h2>
    <h3>Turn manual input for weights on and off. </h3>

     <script type="text/javascript">
         function onSuccess_checkIfEnabled(isEnabled, ctx, methodName) {
             if (isEnabled == true) {
                 $('#manualWeights').prop('checked', true);

                 // jquery < 1.5 $('#manualWeights').attr('checked', true);
             }
             else {
                 $('#manualWeights').prop('checked', false);

                 // jquery < 1.5 $('#manualWeights').attr('checked', false);
             }
         }

         function onFail_checkIfEnabled(value, ctx, methodName) {
             sendtoErrorPage("Error in AdminMainPage.aspx onFail_checkIfEnabled");
         }

         function onSuccess_updateManualInputValue(isEnabled, ctx, methodName) {

         }

         function onFail_updateManualInputValue(value, ctx, methodName) {
             sendtoErrorPage("Error in AdminMainPage.aspx onFail_updateManualInputValue");
         }
         //start
         $(function () {
             $("input[type=checkbox]").on("click", updateManualWeightValue);
             PageMethods.checkIfEnabled(onSuccess_checkIfEnabled, onFail_checkIfEnabled);
         }); <%--end $(function () --%>


         var updateManualWeightValue = function () {
             if (document.getElementById('manualWeights').checked) {
                 //enable
                 PageMethods.updateManualInputValue(true, onSuccess_updateManualInputValue, onFail_updateManualInputValue);
             } else {
                 //disable
                 PageMethods.updateManualInputValue(false, onSuccess_updateManualInputValue, onFail_updateManualInputValue);
             }
         };

         

 </script>
    
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <%--<h2>Check the box if you would like to allow manual input for the weight taken at the guard station or uncheck if you do not. The guard station page must refresh the page for changes to take effect.</h2>--%>
        <br />
        <br />
    
    <table id ="adminSettings">
        <tr id="asManualWeightInput"><td>Allow manual input for weights: </td><td><input type="checkbox" id="manualWeights"></td></tr>
    </table>
    

</asp:Content>