local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse-osee') {
  settings+: {
    description: "",
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
      default_workflow_permissions: "write",
    },
  },
  webhooks+: [
    orgs.newOrgWebhook('https://ci.eclipse.org/osee/github-webhook/') {
      content_type: "json",
      events+: [
        "pull_request",
        "push"
      ],
    },
  ],
  _repositories+:: [
    orgs.newRepo('osee-website') {
      description: "OSEE Website",
      homepage: "https://eclipse.dev/osee/",
      allow_merge_commit: false,
      allow_rebase_merge: true,
      allow_squash_merge: true,
      allow_update_branch: true,
      delete_branch_on_merge: true,
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          requires_linear_history: true,
          required_approving_review_count: 2,
        },
      ]
    },
    orgs.newRepo('org.eclipse.osee') {
      description: "Open System Engineering Environment",
      homepage: "https://eclipse.dev/osee/",
      allow_auto_merge: true,
      allow_merge_commit: false,
      allow_rebase_merge: true,
      allow_squash_merge: true,
      allow_update_branch: true,
      default_branch: "main",
      delete_branch_on_merge: true,
      gh_pages_build_type: "workflow",
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          requires_linear_history: true,
          required_approving_review_count: 2,
          requires_strict_status_checks: true,
          required_status_checks : [
            "eclipse-eca-validation:eclipsefdn/eca",
            "validate_osee_build_linux",
          ],
        },
      ],
      environments: [
        orgs.newEnvironment('github-pages') {
        },
      ]
    },
    orgs.newRepo('org.eclipse.ote') {
      description: "OSEE Test Environment",
      homepage: "https://eclipse.dev/osee/",
      allow_auto_merge: true,
      allow_merge_commit: false,
      allow_rebase_merge: true,
      allow_squash_merge: true,
      allow_update_branch: true,
      default_branch: "temp_main",
      delete_branch_on_merge: true,
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          requires_linear_history: true,
          required_approving_review_count: 2,
        },
      ]
    }
  ],
}
