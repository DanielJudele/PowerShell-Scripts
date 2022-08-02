Function Show-Term()
{
	param(
        [Parameter(Mandatory = $true)]
        [Microsoft.SharePoint.Client.Taxonomy.Term]$Term
	)
	
    Write-host $Term.Name
        
	if($Term.TermsCount -eq 0){
		return
	}

	#Get All child terms
	$childTerms = $Term.Terms
 
    #Process all child terms
    Foreach ($childTerm in $childTerms)
    {
        $indent = $indent +"`t"
        Write-Host $indent -NoNewline
        Show-Term($childTerm)
    }

    $indent = "`t"
}
