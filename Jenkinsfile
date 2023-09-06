pipeline{
    environment{
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        // KUBECONFIG = credentials('jenkins_config')
    }
    agent any
    stages {
                stage("Clean-up") {
            steps {
                deleteDir()
            }
        }
        stage('Checkout Source'){
            steps{
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/janit-chawla/notejam.git'
            }
        }
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Build Image'){
            steps {
                sh 'docker build -t janit31/my-notejam --no-cache .'
            }
        }
        
        stage('Pushing Image'){
            steps{
                sh 'docker push janit31/my-notejam'
            }
        }
        stage('setup kubeconfig') {
          steps {
            withCredentials([file(credentialsId: 'jenkins_config1', variable: 'jenkins_config1')]) {
                sh "cp \${jenkins_config1} ${WORKSPACE}/jenkins_config1"
            }
          }
    }
        stage('Databse'){
            steps{
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 config set-context --current --user=jenkins-admin'
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 apply -f postgres-secret.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 apply -f postgres-deploy.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 apply -f postgres-service.yaml'
                // sh 'kubectl --kubeconfig $KUBECONFIG apply -f /var/jenkins_home/workspace/notejam_main/postgres-secret.yaml'
                // sh 'kubectl --kubeconfig $KUBECONFIG apply -f /var/jenkins_home/workspace/notejam_main/postgres-deploy.yaml'
                // sh 'kubectl --kubeconfig $KUBECONFIG apply -f /var/jenkins_home/workspace/notejam_main/postgres-service.yaml'
                // sh 'kubectl --kubeconfig $KUBECONFIG apply -f /var/jenkins_home/workspace/notejam_main/persistentvolume.yaml'
                // sh 'kubectl --kubeconfig $KUBECONFIG apply -f /var/jenkins_home/workspace/notejam_main/persistentvolumeclaim.yaml'
            }
        }
        stage("Notejam"){
            steps{
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 config set-context --current --user=jenkins-admin'
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 apply -f persistentvolume.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 apply -f persistentvolumeclaim.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/jenkins_config1 apply -f deployment.yaml'
                // sh 'kubectl --kubeconfig $KUBECONFIG apply -f /var/jenkins_home/workspace/notejam_main/deployment.yaml'
            }
        }

    }
    post {
    always {
      sh 'docker logout'
    }
  }
}
