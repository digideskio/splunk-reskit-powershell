# Copyright 2011 Splunk, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"): you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# install script for Splunk PowerShell Resource Kit

param( 
    [Parameter()]
    [string]
    # the path to a folder into which to install the Splunk PowerShell module.  defaults to the user-specific module path for the current user.  the folder is created if it does not already exist.
    $modulePath = ( $env:psmodulepath -split ';' | select -first 1 ),
    
    [Parameter()]
    [switch]
    # specify to overwrite any existing Splunk module in the specified module path
    $force
)

if( ( test-path "$modulePath/Splunk" ) )
{
    if( $force )
    {
        write-verbose "removing existing Splunk module from '$modulePath'";
        ri "$modulePath/Splunk" -recurse -force;
    }
    else
    {
        write-error "Unable to copy module - a Splunk module is already installed at '$modulePath'.  Specify the -force parameter to overwite an existing Splunk module.";
        return;
    }
}

if( -not( Test-Path $modulePath ) )
{
	Write-Verbose "creating module folder at '$modulePath'";
	mkdir $modulePath | out-null;
}

# copy the Splunk folder from the Source hive to the specified Module hive
write-verbose "copying Splunk module from '$pwd' to '$modulePath'";
cp ./Source/Splunk -force:$force -rec -container -dest $modulePath;

<#
.SYNOPSIS 
Installs the Splunk PowerShell module into the PowerShell module path.

.DESCRIPTION
Installs the Splunk PowerShell module into the PowerShell module path.  By default, the module is installed to the module hive for the current user.

.INPUTS
This script does not accept pipeline input.

.OUTPUTS
This script does not produce pipeline output.

.EXAMPLE
C:\PS> ./install.ps1

Installs the Splunk module into the default location (the user-based module location for the current user).  This command will produce an error if a Splunk module is already present.  To bypass this error, specify the -force parameter.

.EXAMPLE
C:\PS> ./install.ps1 -modulePath 'c:\modules' -force

Installs the splunk module into the custom module location 'C:\Modules'.  Any Splunk module existing in the custom location is overwritten without warning.
Note that installing to a custom location is not common; please consult the PowerShell documentation topic about_modules before considering such an action.

.LINK
about_Modules
#>
