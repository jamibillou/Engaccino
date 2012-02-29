#REVEALS TRASH LINK WHEN MOUSE OVER CARD
$ ->
  $("#container div").each ->
    revealItem("destroy_"+$(this).attr("id"), $(this).attr("id")) if ($(this).attr("id") and ($(this).attr("id").indexOf("user_") is 0 or $(this).attr("id").indexOf("candidate_") is 0 or $(this).attr("id").indexOf("recruiter_") is 0))
