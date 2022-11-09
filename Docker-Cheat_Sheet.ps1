function information_Docker {
    Add-Type -AssemblyName PresentationCore, PresentationFramework
    $Xaml = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    Title="Just Answer The Questions..."
    Height="964"
    Width="500"
    WindowStyle="None"
    ResizeMode="CanResize"
    AllowsTransparency="True"
    WindowStartupLocation="CenterScreen"
    Background="Black"
    Foreground="Green"
    Opacity="1" >
    <Window.Resources>
    <Style TargetType="Button" x:Key="RoundButton">
    <Style.Resources>
        <Style TargetType="Border">
            <Setter Property="CornerRadius" Value="5" />
        </Style>
    </Style.Resources>
    </Style>
    <Style TargetType="{x:Type TextBox}">
    <Style.Resources>
        <Style TargetType="{x:Type Border}">
            <Setter Property="CornerRadius" Value="3" />
        </Style>
    </Style.Resources>
    </Style>
    </Window.Resources>
    <Grid>
    <Grid Height="30" HorizontalAlignment="Stretch" VerticalAlignment="Top" Background="#FF474747">
    <StackPanel Orientation="Horizontal">
        <Button Name="close_btn" Foreground="Azure" Height="20" Width="20" Background="Transparent" Content="X" FontSize="14" Margin="10,0,0,0" FontWeight="Bold" Style="{DynamicResource RoundButton}"/>
        <Button Name="minimize_btn" Foreground="Azure" Height="20" Width="20" Background="Transparent" Content="-" FontSize="14" Margin="2 0 0 0" FontWeight="Bold" Style="{DynamicResource RoundButton}"/>
        <TextBlock Text="Alan's Docker Cheat-Sheet" Foreground="Green" Margin="306 4 0 0"/>
    </StackPanel>
    </Grid>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,305,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="480"><Run FontWeight="Bold" Text="Create and run a container from an image, with a custom name:"/><LineBreak/><Run Foreground="Azure"  Text="docker run --name &lt;container_name&gt; &lt;image_name&gt;"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,337,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="480"><Run FontWeight="Bold" Text="Run a container with and publish a container's port(s) to the host."/><LineBreak/><Run Foreground="Azure"  Text="docker run -p &lt;host_port&gt;:&lt;container_port&gt; &lt;image_name&gt;"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="25,667,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Run a container in the background"/><LineBreak/><Run  Foreground="Azure" Text="docker run -d &lt;image_name&gt;"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,371,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Start or stop an existing container:"/><LineBreak/><Run Foreground="Azure" Text="docker start|stop &lt;container_name&gt; (or &lt;container-id&gt;)"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,403,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Remove a stopped container:"/><LineBreak/><Run  Foreground="Azure" Text="docker rm &lt;container_name&gt;"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,503,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="To inspect a running container:"/><LineBreak/><Run  Foreground="Azure" Text="docker inspect &lt;container_name&gt; (or &lt;container_id&gt;)"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,437,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Open a shell inside a running container:"/><LineBreak/><Run  Foreground="Azure" Text="docker exec -it &lt;container_name&gt; sh"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,470,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Fetch and follow the logs of a container:"/><LineBreak/><Run  Foreground="Azure" Text="docker logs -f &lt;container_name&gt;"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,535,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="To inspect a running container:"/><LineBreak/><Run  Foreground="Azure" Text="docker inspect &lt;container_name&gt; (or &lt;container_id&gt;)"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="25,601,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="List all docker containers (running and stopped):"/><LineBreak/><Run  Foreground="Azure" Text="docker ps --all"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,569,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="To list currently running containers:"/><LineBreak/><Run  Foreground="Azure" Text="docker ps"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,635,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="View resource usage stats"/><LineBreak/><Run  Foreground="Azure" Text="docker container stats"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,221,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run Text="A container is a runtime instance of a docker image. A container"/><LineBreak/><Run Text="will always run the same, regardless of the infrastructure."/><LineBreak/><Run Text="Containers isolate software from its environment and ensure"/><LineBreak/><Run Text="that it works uniformly despite differences for instance between"/><LineBreak/><Run Text="development and staging."/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,135,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Get help with Docker. Can also use –help on all subcommands"/><LineBreak/><Run  Foreground="Azure" Text="docker --help"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,102,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Start the docker daemon"/><LineBreak/><Run  Foreground="Azure" Text="docker -d"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,168,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Display system-wide information"/><LineBreak/><Run  Foreground="Azure" Text="docker info"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,886,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Delete an Image"/><LineBreak/><Run Foreground="Azure" Text="docker rmi &lt;image_name&gt; "/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,854,0,0" TextWrapping="Wrap" VerticalAlignment="Top" RenderTransformOrigin="-1.777,5.351"><Run FontWeight="Bold" Text="List local images"/><LineBreak/><Run  Foreground="Azure"  Text="docker images"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="23,728,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run Text="Docker images are a lightweight, standalone, executable package"/><LineBreak/><Run Text="of software that includes everything needed to run an application:"/><LineBreak/><Run Text="code, runtime, system tools, system libraries and settings."/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="328,43,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Docker Documenation"/><LineBreak/><Run  Foreground="Azure"  Text="https://docs.docker.com/"/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,920,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Remove all unused images"/><LineBreak/><Run Foreground="Azure" Text="docker image prune "/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,822,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Build an Image from a Dockerfile without the cache"/><LineBreak/><Run  Foreground="Azure" Text="docker build -t &lt;image_name&gt; . –no-cache "/></TextBlock>
    <TextBlock HorizontalAlignment="Left" FontFamily="Consolas" Margin="24,788,0,0" TextWrapping="Wrap" VerticalAlignment="Top"><Run FontWeight="Bold" Text="Build an Image from a Dockerfile"/><LineBreak/><Run  Foreground="Azure" Text="docker build -t &lt;image_name&gt; "/></TextBlock>
    <GroupBox Header="General Commands:" Margin="10,80,10,759"/>
    <GroupBox Header="Containers:" Margin="10,203,10,264"/>
    <GroupBox Header="Docker Images:" Margin="10,700,10,10"/>

    </Grid>
    </Window>   
    
    
"@
    
    
    #-------------------------------------------------------------#
    #                      Window Function                        #
    #-------------------------------------------------------------#
    $Window = [Windows.Markup.XamlReader]::Parse($Xaml)
    
    [xml]$xml = $Xaml
    
    $xml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) }
    
    #-------------------------------------------------------------#
    #                  Define Window Move                         #
    #-------------------------------------------------------------#
    
    #Click and Drag WPF window without title bar (ChromeTab or whatever it is called)
    $Window.Add_MouseLeftButtonDown({
        $Window.DragMove()
    })
    
    
    #-------------------------------------------------------------#
    #                      Define Buttons                         #
    #-------------------------------------------------------------#
    
    #Custom Close Button
    $close_btn.add_Click({
        $Window.Close();
    })
    #Custom Minimize Button
    $minimize_btn.Add_Click({
        $Window.WindowState = 'Minimized'
    })

    
    #-------------------------------------------------------------#
    #                   Define Conditionals                       #
    #-------------------------------------------------------------#
    
    #Show Window, without this, the script will never initialize the OSD of the WPF elements.
    $Window.ShowDialog()
    
    }
