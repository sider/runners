<?php declare(strict_types=1);

namespace Sider\PHPStan\ErrorFormatter;

use Nette\Utils\Json;
use PHPStan\Command\AnalysisResult;
use PHPStan\Command\ErrorFormatter\ErrorFormatter;
use PHPStan\Command\Output;

class SiderErrorFormatter implements ErrorFormatter
{
    public function formatErrors(AnalysisResult $analysisResult, Output $output): int
    {
        $errors = array();

        foreach ($analysisResult->getFileSpecificErrors() as $fileSpecificError) {
            $errors[] = $fileSpecificError->jsonSerialize();
        }

        $json = Json::encode($errors);
        $output->writeRaw($json);

        return 0;
    }
}
