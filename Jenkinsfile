pipeline {
    agent any
       environment { 

        registry = "santu458/webappsantu" 
        registryCredential = 'dockerhubID' 
        dockerImage = '' 

    }

    stages {
        stage ("Git Checkout") {
            steps {
                git branch: "main", url: "https://github.com/pns99/santu_app.git"
            }
        }
        stage ("Maven Build") {
        
            steps {
                sh "/opt/apache-maven-3.8.6/bin/mvn clean package -DskipTests=true"
                sh "id -a"
            }
        }
        
        stage ("Sonar Publish") {
              steps {
                  withSonarQubeEnv("sonar") {
                      sh "/opt/apache-maven-3.8.6/bin/mvn sonar:sonar"
                  }
              }
        }
        
        stage ("Sonar Quality Gate status Checks") {
              steps {
                 script {
                    timeout(time: 1, unit: "HOURS") {
                        def qg = waitForQualityGate()
                        if (qg.status != "OK") {
                            error "Aborting the pipeline due to Quality Gate failed: ${qg.status}"
                        }
                    }
                }
            }
        }

        
        stage ("Build the docker image") {
            steps {
                script {
                dockerImage = docker.build registry + ":$BUILD_NUMBER" 
                sh "docker images"
                }
            }
        }
              
        stage ("Push image to dockerhub") {
            steps {
                script {
                     docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push()
                                                         
                    }
                }
            }
        }
        stage('Cleaning up') { 
           steps { 
                sh "docker rmi $registry:$BUILD_NUMBER" 
           } 
        }
        stage ("UAT Deploy") {
            steps {
                echo "${env.BUILD_NUMBER}"
                        println "${env.BUILD_NUMBER}"
                        sh "ansible-playbook  UAT-deploy.yaml -e BUILD_NUMBER=${env.BUILD_NUMBER}"
            }
        }
    }
}
