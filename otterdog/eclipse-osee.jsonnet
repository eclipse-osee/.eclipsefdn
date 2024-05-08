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
      allow_ff_only: true, 
      allow_merge_commit: false,
      allow_rebase_merge: false,
      allow_squash_merge: false,
      allow_update_branch: false,
      default_branch: "main",
      delete_branch_on_merge: false,
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
      branch_protection_rules: [
        {
          name: "Two Review Policy with Eclipse Committer",
          conditions: [
            {
              name: "Default branch protection",
              type: "Branch",
              pattern: "main",
              branches: ["main"],
              actions: {
                merge: {
                  enabled: true,
                  approvals: 2,
                  committer_approvals: 1
                }
              }
            }
          ],
          restrictions: {
            allow_ff: true
          }
        }
      ]
    }
  ],
}
