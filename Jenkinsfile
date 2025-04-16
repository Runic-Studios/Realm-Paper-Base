@Library('Jenkins-Shared-Lib') _

pipeline {
    agent {
        kubernetes {
            yaml jenkinsAgent(['agent-base': 'registry.runicrealms.com/jenkins/agent-base:latest'])
        }
    }

    environment {
        ARTIFACT_NAME = 'realm-paper-base'
        PROJECT_NAME = 'Realm Paper Base'
        REGISTRY = 'registry.runicrealms.com'
        REGISTRY_PROJECT = 'library'
    }

    stages {
        stage('Send Discord Notification (Build Start)') {
            steps {
                discordNotifyStart(env.PROJECT_NAME, env.GIT_URL, env.GIT_BRANCH, env.GIT_COMMIT.take(7))
            }
        }
        stage('Determine Environment') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH.replaceAll(/^origin\//, '').replaceAll(/^refs\/heads\//, '')

                    echo "Using normalized branch name: ${branchName}"

                    if (branchName == 'dev') {
                        env.RUN_MAIN_DEPLOY = 'false'
                    } else if (branchName == 'main') {
                        env.RUN_MAIN_DEPLOY = 'true'
                    } else {
                        error "Unsupported branch: ${branchName}"
                    }
                }
            }
        }
        stage('Zip and Push Artifact') {
            steps {
                container('agent-base') {
                    script {
                        sh """
                        cd server
                        zip -r "../artifact.zip" .
                        """
                        orasPush(env.ARTIFACT_NAME, env.GIT_COMMIT.take(7), "artifact.zip", env.REGISTRY, env.REGISTRY_PROJECT)
                    }
                }
            }
        }
        stage('Update Deployment') {
            steps {
                container('agent-base') {
                    updateManifest('dev', 'Realm-Paper', 'artifact-manifest.yaml', env.ARTIFACT_PAPER_NAME, env.GIT_COMMIT.take(7), 'artifacts.realm-paper-base.tag')
                }
            }
        }
        stage('Create PR to Promote Realm-Deployment Dev to Main (Prod Only)') {
            when {
                expression { return env.RUN_MAIN_DEPLOY == 'true' }
            }
            steps {
                container('agent-base') {
                    createPR('Realm-Paper-Base', 'Realm-Paper', 'dev', 'main')
                }
            }
        }
    }

    post {
        success {
            discordNotifySuccess(env.PROJECT_NAME, env.GIT_URL, env.GIT_BRANCH, env.GIT_COMMIT.take(7))
        }
        failure {
            discordNotifyFail(env.PROJECT_NAME, env.GIT_URL, env.GIT_BRANCH, env.GIT_COMMIT.take(7))
        }
    }
}
