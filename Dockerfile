FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["ReportService.csproj","./"]
RUN dotnet restore "./ReportService.csproj"
COPY . .
RUN dotnet build "ReportService.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ReportService.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet","ReportService.dll"]