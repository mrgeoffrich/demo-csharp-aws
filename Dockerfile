FROM microsoft/dotnet:2.2-sdk AS build-env

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -yq nodejs

WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out ./
ENTRYPOINT ["dotnet", "demo-csharp-aws.dll"]