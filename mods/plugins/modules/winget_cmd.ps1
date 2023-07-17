#!powershell

#AnsibleRequires -CSharpUtil Ansible.Basic
#AnsibleRequires -PowerShell Ansible.ModuleUtils.AddType

Set-StrictMode -Version "Latest"

$spec = @{
    options = @{
        id = @{ type = "str"; required = $true }
        state = @{ type = "str"; choices = "absent", "present" }
    }
}

[Ansible.Basic.AnsibleModule]$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

function Run-Winget {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [Ansible.Basic.AnsibleModule]
        $Module,

        [Parameter(Mandatory = $true)]
        [Ansible.Basic.AnsibleModule]
        $Id,

        [Parameter()]
        [String]
        $State
    )

    Process {
        [string]$output = ""
        if ((-not $State) -or ($State -eq 'present')) {
            return output = winget install --id $Id --extract
        } else {
            return winget uninstall --id $Id --extract
        }
    } # end Process
} # end function

$module.Result.output = Run-Winget -Module $module -Id $id -State $state
$module.ExitJson()
