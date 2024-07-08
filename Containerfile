# Import the base image as UBI-Nodejs 18 image
FROM image-registry.openshift-image-registry.svc:5000/openshift/nodejs:16-ubi8

# Set the working directory to /project
WORKDIR /project

# Copy package files in container currunt direcctory
COPY --chown=1001:1001 package.json package-lock.json ./

# Configure this in case you need to build from a private repository, just change the url to ur registry url
# RUN npm config set registry http://localhost:8080/repository/my-org/

# Install all Angular dependacies
RUN npm ci

# Add application files in container 
COPY . .

# Set permision of .angular file in container
VOLUME ["/project/.angular"]

# Open port to allow traffic in container
EXPOSE 8080

# Run start script using npm command
CMD ["npm", "start"]
