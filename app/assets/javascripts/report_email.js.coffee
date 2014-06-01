class @ReportEmailPopup
  @openEmailModal: =>
    $('#email-modal').modal('show')

$ ->
  $("#send-email-btn").click(->
    QueryReport.sendEmail($("#email-to").val(), $("#email-subject").val(), $("#mail-message").val())
  )