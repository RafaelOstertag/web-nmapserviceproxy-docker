pipeline {
    agent {
        label "arm64&&docker"
    }

    triggers {
        pollSCM '@hourly'
    }

    options {
        ansiColor('xterm')
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '15')
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        string defaultValue: 'none', description: 'Version of Artifact in Nexus', name: 'VERSION', trim: true
        booleanParam defaultValue: false, description: 'Deploy to Kubernetes', name: 'DEPLOY'
    }

    environment {
        DOCKER_CRED=credentials("750504ce-6f4f-4252-9b2b-5814bd561430")
    }

    stages {
        stage('Build & Push Docker Image') {
            when {
                allOf {
                    expression { return params.VERSION != 'none' }
                    expression { return params.VERSION != '' }
                }
            }

            steps {
                sh 'docker build --build-arg VERSION=${VERSION} -t $DOCKER_CRED_USR/nmap-service-proxy:${VERSION} .'
                sh 'docker login --username "$DOCKER_CRED_USR" --password "$DOCKER_CRED_PSW"'
                sh 'docker push $DOCKER_CRED_USR/nmap-service-proxy:${VERSION}'
            }
        }

        stage('Trigger deploy') {
            when {
                expression { return params.DEPLOY }
                allOf {
                    expression { return params.VERSION != 'none' }
                    expression { return params.VERSION != '' }
                }
            }

            steps {
                build wait: false, job: '../Helm/nmapserviceproxy', parameters: [string(name: 'VERSION', value: params.VERSION)]
            }
        }
    }

    post {
        always {
            mail to: "rafi@guengel.ch",
                    subject: "${JOB_NAME} (${env.BUILD_DISPLAY_NAME}) -- ${currentBuild.currentResult}",
                    body: "Refer to ${currentBuild.absoluteUrl}"
        }
    }
}
