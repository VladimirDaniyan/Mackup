function today
    set -l dir scratch-(date "+%Y%m%d")
    mkdir -p ~/tmp/$dir
    echo ~/tmp/$dir
end

