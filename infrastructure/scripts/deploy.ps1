# execute: ./deploy.ps1 -Environment "dev" -ResourceGroupName "mmt-dev"

# Parameters
param (
    [string]$Environment = "dev",
    [string]$ResourceGroupName = "cars-unlimited-dev",
    [string]$Location = "eastus",
    [string]$TemplateFile = "../main.bicep",
    [string]$ParametersFile = "../parameters/$Environment.params.json"
)

# Error Handling
function Handle-Error {
    param (
        [string]$ErrorMessage
    )
    Write-Host "Error: $ErrorMessage" -ForegroundColor Red
    exit 1
}

try {
    # Install Bicep CLI
    Write-Host "Installing Bicep CLI..."
    az bicep install
    if ($LASTEXITCODE -ne 0) {
        Handle-Error "Failed to install Bicep CLI."
    }

    # Create the resource group
    Write-Host "Creating or updating resource group '$ResourceGroupName'..."
    az group create --name $ResourceGroupName --location $Location
    if ($LASTEXITCODE -ne 0) {
        Handle-Error "Failed to create or update resource group."
    }

    # Build
    Write-Host "Building Bicep file..."
    az bicep build --file $TemplateFile
    if ($LASTEXITCODE -ne 0) {
        Handle-Error "Failed to build Bicep file."
    }

    # Validate
    Write-Host "Validating Bicep template..."
    az deployment group validate `
        --resource-group $ResourceGroupName `
        --template-file $TemplateFile `
        --parameters $ParametersFile
    if ($LASTEXITCODE -ne 0) {
        Handle-Error "Bicep template validation failed."
    }

    #What-If
    Write-Host "Running Bicep What-If..."
    az deployment group what-if `
        --resource-group $ResourceGroupName `
        --template-file $TemplateFile `
        --parameters $ParametersFile

    if ($LASTEXITCODE -ne 0) {
        Handle-Error "Bicep What-If failed."
    }

    # Prompt
    Write-Host "Do you want to proceed with the deployment? (y/n)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -ne "y") {
        Write-Host "Deployment cancelled by user." -ForegroundColor Red
        exit 0
    }

    # Deploy
    Write-Host "Deploying infrastructure..."
    az deployment group create `
        --resource-group $ResourceGroupName `
        --template-file $TemplateFile `
        --parameters $ParametersFile
    if ($LASTEXITCODE -ne 0) {
        Handle-Error "Infrastructure deployment failed."
    }

    Write-Host "Infrastructure deployment completed successfully!" -ForegroundColor Green
}
catch {
    Handle-Error $_Exception.Message
}